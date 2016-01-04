import UIKit

let shout = ShoutView()

public func Shout(announcement: Announcement, to: UIViewController, completion: (() -> ())? = {}) {
  shout.craft(announcement, to: to, completion: completion)
}

public class ShoutView: UIView {

  public struct Dimensions {
    public static let indicatorHeight: CGFloat = 6
    public static let indicatorWidth: CGFloat = 50
    public static let imageSize: CGFloat = 48
    public static let imageOffset: CGFloat = 18
    public static var height: CGFloat = UIApplication.sharedApplication().statusBarHidden ? 70 : 80
    public static var textOffset: CGFloat = 75
  }

  public private(set) lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorList.Shout.background
    view.alpha = 0.98
    view.clipsToBounds = true

    return view
    }()

  public private(set) lazy var gestureContainer: UIView = {
    let view = UIView()
    view.userInteractionEnabled = true

    return view
    }()

  public private(set) lazy var indicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorList.Shout.dragIndicator
    view.layer.cornerRadius = Dimensions.indicatorHeight / 2
    view.userInteractionEnabled = true

    return view
    }()

  public private(set) lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Dimensions.imageSize / 2
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill

    return imageView
    }()

  public private(set) lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = FontList.Shout.title
    label.textColor = ColorList.Shout.title
    label.numberOfLines = 1

    return label
    }()

  public private(set) lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = FontList.Shout.subtitle
    label.textColor = ColorList.Shout.subtitle
    label.numberOfLines = 1

    return label
    }()

  public private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: "handleTapGestureRecognizer")

    return gesture
    }()

  public private(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
    let gesture = UIPanGestureRecognizer()
    gesture.addTarget(self, action: "handlePanGestureRecognizer")

    return gesture
    }()

  public private(set) var announcement: Announcement?
  public private(set) var displayTimer = NSTimer()
  public private(set) var panGestureActive = false
  public private(set) var shouldSilent = false
  public private(set) var completion: (() -> ())?

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(backgroundView)
    [indicatorView, imageView, titleLabel, subtitleLabel, gestureContainer].forEach {
      backgroundView.addSubview($0) }

    clipsToBounds = false
    userInteractionEnabled = true
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0.5)
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 0.5

    addGestureRecognizer(tapGestureRecognizer)
    gestureContainer.addGestureRecognizer(panGestureRecognizer)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  // MARK: - Configuration

  public func craft(announcement: Announcement, to: UIViewController, completion: (() -> ())?) {
    Dimensions.height = UIApplication.sharedApplication().statusBarHidden ? 70 : 80

    panGestureActive = false
    shouldSilent = false
    configureView(announcement)
    shout(to: to)

    self.completion = completion
  }

  public func configureView(announcement: Announcement) {
    self.announcement = announcement
    imageView.image = announcement.image
    titleLabel.text = announcement.title
    subtitleLabel.text = announcement.subtitle ?? ""
    
    [titleLabel, subtitleLabel].forEach {
      $0.sizeToFit()
    }

    if imageView.image == nil { Dimensions.textOffset = 18 }

    displayTimer.invalidate()
    displayTimer = NSTimer.scheduledTimerWithTimeInterval(announcement.duration,
      target: self, selector: "displayTimerDidFire", userInfo: nil, repeats: false)
    setupFrames()
  }

  public func shout(to controller: UIViewController) {
    guard let controller = controller.navigationController else { fatalError("The controller must contain a navigation bar") }

    let width = UIScreen.mainScreen().bounds.width
    controller.view.addSubview(self)

    frame = CGRect(x: 0, y: 0, width: width, height: 0)
    backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: 0)

    UIView.animateWithDuration(0.35, animations: {
      self.frame.size.height = Dimensions.height
      self.backgroundView.frame.size.height = self.frame.height
    })
  }

  // MARK: - Setup

  public func setupFrames() {
    let totalWidth = UIScreen.mainScreen().bounds.width
    let offset: CGFloat = UIApplication.sharedApplication().statusBarHidden ? 2.5 : 5

    backgroundView.frame.size = CGSize(width: totalWidth, height: Dimensions.height)
    gestureContainer.frame = CGRect(x: 0, y: Dimensions.height - 20, width: totalWidth, height: 20)
    indicatorView.frame = CGRect(x: (totalWidth - Dimensions.indicatorWidth) / 2,
      y: Dimensions.height - Dimensions.indicatorHeight - 5, width: Dimensions.indicatorWidth, height: Dimensions.indicatorHeight)
    imageView.frame = CGRect(x: Dimensions.imageOffset, y: (Dimensions.height - Dimensions.imageSize) / 2 + offset,
      width: Dimensions.imageSize, height: Dimensions.imageSize)
    titleLabel.frame.origin = CGPoint(x: Dimensions.textOffset, y: imageView.frame.origin.y + 3)
    subtitleLabel.frame.origin = CGPoint(x: Dimensions.textOffset, y: CGRectGetMaxY(titleLabel.frame) + 2.5)

    if let text = subtitleLabel.text where text.isEmpty {
      titleLabel.center.y = imageView.center.y - 2.5
    }

    [titleLabel, subtitleLabel].forEach {
      $0.frame.size.width = totalWidth - Dimensions.imageSize - (Dimensions.imageOffset * 2) }
  }

  // MARK: - Actions

  public func silent() {
    UIView.animateWithDuration(0.35, animations: {
      self.frame.size.height = 0
      self.backgroundView.frame.size.height = self.frame.height
      }, completion: { finished in
        self.completion?()
        self.displayTimer.invalidate()
        self.removeFromSuperview()
    })
  }

  // MARK: - Timer methods

  public func displayTimerDidFire() {
    shouldSilent = true

    if panGestureActive { return }
    silent()
  }

  // MARK: - Gesture methods

  @objc private func handleTapGestureRecognizer() {
    guard let announcement = announcement else { return }
    announcement.action?()
    silent()
  }

  @objc private func handlePanGestureRecognizer() {
    let translation = panGestureRecognizer.translationInView(self)
    var duration: NSTimeInterval = 0

    if panGestureRecognizer.state == .Changed || panGestureRecognizer.state == .Began {
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
      UIView.animateWithDuration(duration, animations: {
        self.frame.size.height = height
        }, completion: { _ in if translation.y < -5 { self.completion?(); self.removeFromSuperview() }})
    }

    UIView.animateWithDuration(duration, animations: {
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
