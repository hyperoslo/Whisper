import UIKit

let whistleFactory = WhistleFactory()

public func Whistle(murmur: Murmur, to: UIViewController) {
  whistleFactory.whistler(murmur, controller: to)
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

    clipsToBounds = true
    [titleLabel].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration

  public func whistler(murmur: Murmur, controller: UIViewController) {
    titleLabel.text = murmur.title
    titleLabel.font = murmur.font
    titleLabel.textColor = murmur.titleColor
    backgroundColor = murmur.backgroundColor
    viewController = controller

    setupWindow()
    setupFrames()
    present()
  }

  // MARK: - Setup

  public func setupWindow() {

  }

  public func setupFrames() {
    let barFrame = UIApplication.sharedApplication().statusBarFrame

    titleLabel.sizeToFit()

    var yValue: CGFloat = 0
    if let navigationController = viewController?.navigationController
      where !navigationController.navigationBarHidden { yValue = -barFrame.height }

    frame = CGRect(x: 0, y: yValue, width: barFrame.width, height: barFrame.height)
    titleLabel.frame = bounds
  }

  // MARK: - Movement methods

  public func present() {
    hideTimer.invalidate()

    guard let controller = viewController else { return }

    if let navigationController = controller.navigationController
      where !navigationController.navigationBarHidden {
        navigationController.navigationBar.addSubview(self)
    } else {
      controller.view.addSubview(self)
    }

    let initialOrigin = frame.origin.y
    frame.origin.y = initialOrigin - UIApplication.sharedApplication().statusBarFrame.height
    alpha = 1
    UIView.animateWithDuration(0.2, animations: {
      self.frame.origin.y = initialOrigin
      self.alpha = 1
    })

    window?.windowLevel = UIWindowLevelStatusBar + 1

    hideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "timerDidFire", userInfo: nil, repeats: false)
  }

  public func hide() {
    let finalOrigin = frame.origin.y - UIApplication.sharedApplication().statusBarFrame.height
    UIView.animateWithDuration(0.2, animations: {
      self.frame.origin.y = finalOrigin
      self.alpha = 0
      }, completion: { _ in
        self.window?.windowLevel = UIWindowLevelNormal
        self.removeFromSuperview()
    })
  }

  // MARK: - Timer methods

  public func timerDidFire() {
    hide()
  }
}
