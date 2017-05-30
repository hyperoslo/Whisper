import UIKit

let shoutView = ShoutView()

open class ShoutView: UIView {

  public struct Dimensions {
    public static var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 1, left: 18, bottom: 1, right: 18)
    public static var textToImageMargin: CGFloat = 9
    public static let indicatorHeight: CGFloat = 6
    public static let indicatorWidth: CGFloat = 50
    public static let indicatorBottomMargin: CGFloat = 5
    public static var touchOffset: CGFloat = 40
  }

  open fileprivate(set) lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorList.Shout.background
    view.alpha = 0.98
    view.clipsToBounds = true

    return view
    }()

  open fileprivate(set) lazy var indicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorList.Shout.dragIndicator
    view.layer.cornerRadius = Dimensions.indicatorHeight / 2
    view.isUserInteractionEnabled = true

    return view
    }()

  open fileprivate(set) lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Dimensions.imageSize / 2
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill

    return imageView
    }()

  open fileprivate(set) lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = FontList.Shout.title
    label.textColor = ColorList.Shout.title
    label.numberOfLines = 2

    return label
    }()

  open fileprivate(set) lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = FontList.Shout.subtitle
    label.textColor = ColorList.Shout.subtitle
    label.numberOfLines = 2

    return label
    }()

  open fileprivate(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(ShoutView.handleTapGestureRecognizer))

    return gesture
    }()

  open fileprivate(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
    let gesture = UIPanGestureRecognizer()
    gesture.addTarget(self, action: #selector(ShoutView.handlePanGestureRecognizer))

    return gesture
    }()

  open fileprivate(set) var announcement: Announcement?
  open fileprivate(set) var displayTimer = Timer()
  open fileprivate(set) var panGestureActive = false
  open fileprivate(set) var shouldSilent = false
  open fileprivate(set) var completion: (() -> ())?

  private var subtitleLabelOriginalHeight: CGFloat = 0
  private var internalHeight: CGFloat = 0

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(backgroundView)
    [imageView, titleLabel, subtitleLabel, indicatorView].forEach {
      $0.autoresizingMask = []
      backgroundView.addSubview($0)
    }

    clipsToBounds = false
    isUserInteractionEnabled = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0.5)
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 0.5

    backgroundView.addGestureRecognizer(tapGestureRecognizer)
    addGestureRecognizer(panGestureRecognizer)

    NotificationCenter.default.addObserver(self, selector: #selector(ShoutView.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }

  // MARK: - Configuration

  open func craft(_ announcement: Announcement, to: UIViewController, completion: (() -> ())?) {
    panGestureActive = false
    shouldSilent = false
    configureView(announcement)
    shout(to: to)

    self.completion = completion
  }

  open func configureView(_ announcement: Announcement) {
    self.announcement = announcement
    imageView.image = announcement.image
    imageView.sizeToFit()
    titleLabel.text = announcement.title
    subtitleLabel.text = announcement.subtitle

    displayTimer.invalidate()
    displayTimer = Timer.scheduledTimer(timeInterval: announcement.duration,
      target: self, selector: #selector(ShoutView.displayTimerDidFire), userInfo: nil, repeats: false)

    setupFrames()
  }

  open func shout(to controller: UIViewController) {
    controller.view.addSubview(self)

    frame.size.height = 0
    UIView.animate(withDuration: 0.35, animations: {
      self.frame.size.height = self.internalHeight + Dimensions.touchOffset
    })
  }

  // MARK: - Setup

  public func setupFrames() {
    // totalWidth should be dependent on navigation controller's width
    // in which the shout will be shown
    let totalWidth = UIScreen.main.bounds.width
    let spaceBetweenLabels: CGFloat = 2
    let absoluteContentInsets: UIEdgeInsets = UIEdgeInsets(top: Dimensions.contentInsets.top + (UIApplication.shared.isStatusBarHidden ? 0 : 20), left: Dimensions.contentInsets.left, bottom: Dimensions.contentInsets.bottom, right: Dimensions.contentInsets.right)
    
    let textOffsetX = absoluteContentInsets.left + (imageView.image != nil ? imageView.frame.width + Dimensions.textToImageMargin : 0)
    let labelWidth = totalWidth - textOffsetX - absoluteContentInsets.right
    
    var labelsHeight: CGFloat = 0
    var prevView: UIView?
    [titleLabel, subtitleLabel].forEach {
      $0.frame.size.width = labelWidth
      $0.frame.origin.x = textOffsetX
      $0.sizeToFit()
      $0.isHidden = ($0.text ?? "").isEmpty
      if !$0.isHidden {
        labelsHeight += $0.frame.height + (prevView != nil ? spaceBetweenLabels : 0)
        prevView = $0
      }
    }
    
    let contentHeight = max(labelsHeight, imageView.frame.height)
    let indicatorTakenHeight = Dimensions.indicatorBottomMargin + Dimensions.indicatorHeight
    let containerHeight = absoluteContentInsets.top + contentHeight + absoluteContentInsets.bottom + indicatorTakenHeight
    
    imageView.frame.origin.x = absoluteContentInsets.left
    imageView.center.y = absoluteContentInsets.top + (contentHeight / 2)
    
    var labelY = absoluteContentInsets.top + (contentHeight - labelsHeight) / 2
    [titleLabel, subtitleLabel].filter { !$0.isHidden }.forEach {
      $0.frame.origin.y = labelY
      labelY += $0.frame.size.height + spaceBetweenLabels
    }
    
    frame = CGRect(x: 0, y: 0, width: totalWidth, height: containerHeight + Dimensions.touchOffset)
    internalHeight = containerHeight
  }

  // MARK: - Frame

  open override var frame: CGRect {
    didSet {
      backgroundView.frame = CGRect(x: 0, y: 0,
                                    width: frame.size.width,
                                    height: frame.size.height - Dimensions.touchOffset)

      indicatorView.frame = CGRect(x: (backgroundView.frame.size.width - Dimensions.indicatorWidth) / 2,
                                   y: backgroundView.frame.height - Dimensions.indicatorHeight - 5,
                                   width: Dimensions.indicatorWidth,
                                   height: Dimensions.indicatorHeight)
    }
  }

  // MARK: - Actions

  open func silent() {
    UIView.animate(withDuration: 0.35, animations: {
      self.frame.size.height = 0
      }, completion: { finished in
        self.completion?()
        self.displayTimer.invalidate()
        self.removeFromSuperview()
    })
  }

  // MARK: - Timer methods

  open func displayTimerDidFire() {
    shouldSilent = true

    if panGestureActive { return }
    silent()
  }

  // MARK: - Gesture methods

  @objc fileprivate func handleTapGestureRecognizer() {
    guard let announcement = announcement else { return }
    announcement.action?()
    silent()
  }
  
  @objc private func handlePanGestureRecognizer() {
    let translation = panGestureRecognizer.translation(in: self)

    if panGestureRecognizer.state == .began {
      subtitleLabelOriginalHeight = subtitleLabel.bounds.size.height
      subtitleLabel.numberOfLines = 0
      subtitleLabel.sizeToFit()
    } else if panGestureRecognizer.state == .changed {
      panGestureActive = true
      
      let maxTranslation = subtitleLabel.bounds.size.height - subtitleLabelOriginalHeight
      
      if translation.y >= maxTranslation {
        frame.size.height = internalHeight + maxTranslation
          + (translation.y - maxTranslation) / 25 + Dimensions.touchOffset
      } else {
        frame.size.height = internalHeight + translation.y + Dimensions.touchOffset
      }
    } else {
      panGestureActive = false
      let height = translation.y < -5 || shouldSilent ? 0 : internalHeight

      subtitleLabel.numberOfLines = 2
      subtitleLabel.sizeToFit()
      
      UIView.animate(withDuration: 0.2, animations: {
        self.frame.size.height = height + Dimensions.touchOffset
      }, completion: { _ in
          if translation.y < -5 {
            self.completion?()
            self.removeFromSuperview()
        }
      })
    }
  }


  // MARK: - Handling screen orientation

  func orientationDidChange() {
    setupFrames()
  }
}
