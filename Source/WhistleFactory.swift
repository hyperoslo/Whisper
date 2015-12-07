import UIKit

let whistleFactory = WhistleFactory()

public func Whistle(murmur: Murmur) {
  whistleFactory.whistler(murmur)
}

public class WhistleFactory: UIView {

  public lazy var whistleWindow: UIWindow = {
    let window = UIWindow()
    return window
    }()

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Center

    return label
    }()

  public var duration: NSTimeInterval = 2
  public var viewController: UIViewController?
  public var hideTimer = NSTimer()

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    setupWindow()
    clipsToBounds = true
    [titleLabel].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration

  public func whistler(murmur: Murmur) {
    titleLabel.text = murmur.title
    titleLabel.font = murmur.font
    titleLabel.textColor = murmur.titleColor
    backgroundColor = murmur.backgroundColor
    whistleWindow.backgroundColor = murmur.backgroundColor

    setupFrames()
    present()
  }

  // MARK: - Setup

  public func setupWindow() {
    whistleWindow.addSubview(self)
    whistleWindow.windowLevel = UIWindowLevelAlert
    whistleWindow.clipsToBounds = true
  }

  public func setupFrames() {
    titleLabel.sizeToFit()

    whistleWindow.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width,
      height: UIApplication.sharedApplication().statusBarFrame.height)
    frame = whistleWindow.bounds
    titleLabel.frame = bounds
  }

  // MARK: - Movement methods

  public func present() {
    hideTimer.invalidate()

    let initialOrigin = whistleWindow.frame.origin.y
    whistleWindow.frame.origin.y = initialOrigin - UIApplication.sharedApplication().statusBarFrame.height
    whistleWindow.makeKeyAndVisible()
    UIView.animateWithDuration(0.2, animations: {
      self.whistleWindow.frame.origin.y = initialOrigin
    })

    hideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "timerDidFire", userInfo: nil, repeats: false)
  }

  public func hide() {
    let finalOrigin = frame.origin.y - UIApplication.sharedApplication().statusBarFrame.height
    UIView.animateWithDuration(0.2, animations: {
      self.whistleWindow.frame.origin.y = finalOrigin
      }, completion: { _ in
        self.window?.makeKeyAndVisible()
    })
  }

  // MARK: - Timer methods

  public func timerDidFire() {
    hide()
  }
}
