import UIKit

let shoutView = ShoutView()

open class ShoutView: UIView {

  public struct Dimensions {
    public static let indicatorHeight: CGFloat = 6
    public static let indicatorWidth: CGFloat = 50
    public static let imageSize: CGFloat = 48
    public static let imageOffset: CGFloat = 18
    public static var height: CGFloat = UIApplication.shared.isStatusBarHidden ? 70 : 80
    public static var textOffset: CGFloat = 75
  }

  open fileprivate(set) lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorList.Shout.background
    view.alpha = 0.98
    view.clipsToBounds = true

    return view
    }()

  open fileprivate(set) lazy var gestureContainer: UIView = {
    let view = UIView()
    view.isUserInteractionEnabled = true

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

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(backgroundView)
    [indicatorView, imageView, titleLabel, subtitleLabel, gestureContainer].forEach {
      backgroundView.addSubview($0) }

    clipsToBounds = false
    isUserInteractionEnabled = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0.5)
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 0.5

    addGestureRecognizer(tapGestureRecognizer)
    gestureContainer.addGestureRecognizer(panGestureRecognizer)

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
    Dimensions.height = UIApplication.shared.isStatusBarHidden ? 70 : 80

    panGestureActive = false
    shouldSilent = false
    configureView(announcement)
    shout(to: to)

    self.completion = completion
  }

  open func configureView(_ announcement: Announcement) {
    self.announcement = announcement
    imageView.image = announcement.image
    titleLabel.text = announcement.title
    subtitleLabel.text = announcement.subtitle

    displayTimer.invalidate()
    displayTimer = Timer.scheduledTimer(timeInterval: announcement.duration,
      target: self, selector: #selector(ShoutView.displayTimerDidFire), userInfo: nil, repeats: false)

    setupFrames()
  }

  open func shout(to controller: UIViewController) {
    let width = UIScreen.main.bounds.width
    controller.view.addSubview(self)

    frame = CGRect(x: 0, y: 0, width: width, height: 0)
    backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: 0)

    UIView.animate(withDuration: 0.35, animations: {
      self.frame.size.height = Dimensions.height
      self.backgroundView.frame.size.height = self.frame.height
    })
  }

  // MARK: - Setup

  open func setupFrames() {
    let totalWidth = UIScreen.main.bounds.width
    let offset: CGFloat = UIApplication.shared.isStatusBarHidden ? 2.5 : 5
    let textOffsetX: CGFloat = imageView.image != nil ? Dimensions.textOffset : 18
    let imageSize: CGFloat = imageView.image != nil ? Dimensions.imageSize : 0

    backgroundView.frame.size = CGSize(width: totalWidth, height: Dimensions.height)
    gestureContainer.frame = CGRect(x: 0, y: Dimensions.height - 20, width: totalWidth, height: 20)
    indicatorView.frame = CGRect(x: (totalWidth - Dimensions.indicatorWidth) / 2,
      y: Dimensions.height - Dimensions.indicatorHeight - 5, width: Dimensions.indicatorWidth, height: Dimensions.indicatorHeight)

    imageView.frame = CGRect(x: Dimensions.imageOffset, y: (Dimensions.height - imageSize) / 2 + offset,
      width: imageSize, height: imageSize)

    [titleLabel, subtitleLabel].forEach {
      $0.frame.size.width = totalWidth - imageSize - (Dimensions.imageOffset * 2)
      $0.sizeToFit()
    }

    let textOffsetY = imageView.image != nil ? imageView.frame.origin.x + 3 : textOffsetX

    titleLabel.frame.origin = CGPoint(x: textOffsetX, y: textOffsetY)
    subtitleLabel.frame.origin = CGPoint(x: textOffsetX, y: titleLabel.frame.maxY + 2.5)

    if subtitleLabel.text?.isEmpty ?? true {
      titleLabel.center.y = imageView.center.y - 2.5
    }
  }

  // MARK: - Actions

  open func silent() {
    UIView.animate(withDuration: 0.35, animations: {
      self.frame.size.height = 0
      self.backgroundView.frame.size.height = self.frame.height
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

  @objc fileprivate func handlePanGestureRecognizer() {
    let translation = panGestureRecognizer.translation(in: self)
    var duration: TimeInterval = 0

    if panGestureRecognizer.state == .changed || panGestureRecognizer.state == .began {
      panGestureActive = true
      if translation.y >= 12 {
        frame.size.height = Dimensions.height + 12 + (translation.y) / 25
      } else {
        frame.size.height = Dimensions.height + translation.y
      }
    } else {
      panGestureActive = false
      let height = translation.y < -5 || shouldSilent ? 0 : Dimensions.height

      duration = 0.2
      UIView.animate(withDuration: duration, animations: {
        self.frame.size.height = height
        }, completion: { _ in if translation.y < -5 { self.completion?(); self.removeFromSuperview() }})
    }

    UIView.animate(withDuration: duration, animations: {
      self.backgroundView.frame.size.height = self.frame.height
      self.gestureContainer.frame.origin.y = self.frame.height - 20
      self.indicatorView.frame.origin.y = self.frame.height - Dimensions.indicatorHeight - 5
    })
  }


  // MARK: - Handling screen orientation

  func orientationDidChange() {
    setupFrames()
  }
}
