import UIKit

let whistleFactory = WhistleFactory()

public func Whistle(murmur: Murmur) {
  whistleFactory.whistler(murmur)
}

public class WhistleFactory: UIViewController {

  public struct Dimensions {
    public static let height: CGFloat = 20
  }

  public lazy var whistleWindow: UIWindow = UIWindow()

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Center

    return label
    }()

  public var duration: NSTimeInterval = 2
  public var viewController: UIViewController?
  public var hideTimer = NSTimer()

  // MARK: - Initializers

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nil, bundle: nil)

    setupWindow()
    view.clipsToBounds = true
    view.addSubview(titleLabel)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration

  public func whistler(murmur: Murmur) {
    titleLabel.text = murmur.title
    titleLabel.font = murmur.font
    titleLabel.textColor = murmur.titleColor
    view.backgroundColor = murmur.backgroundColor
    whistleWindow.backgroundColor = murmur.backgroundColor

    setupFrames()
    present()
  }

  // MARK: - Setup

  public func setupWindow() {
    whistleWindow.addSubview(self.view)
    whistleWindow.windowLevel = UIWindowLevelStatusBar
    whistleWindow.clipsToBounds = true
  }

  public func setupFrames() {
    titleLabel.sizeToFit()

    whistleWindow.rootViewController = self
    whistleWindow.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width,
      height: Dimensions.height)
    view.frame = whistleWindow.bounds
    titleLabel.frame = view.bounds
  }

  // MARK: - Movement methods

  public func present() {
    hideTimer.invalidate()

    let initialOrigin = whistleWindow.frame.origin.y
    whistleWindow.frame.origin.y = initialOrigin - Dimensions.height
    whistleWindow.makeKeyAndVisible()
    UIView.animateWithDuration(0.2, animations: {
      self.whistleWindow.frame.origin.y = initialOrigin
    })

    hideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "timerDidFire", userInfo: nil, repeats: false)
  }

  public func hide() {
    let finalOrigin = view.frame.origin.y - Dimensions.height
    UIView.animateWithDuration(0.2, animations: {
      self.whistleWindow.frame.origin.y = finalOrigin
      }, completion: { _ in
        self.whistleWindow.resignKeyWindow()
        self.view.window?.makeKeyAndVisible()
    })
  }

  // MARK: - Timer methods

  public func timerDidFire() {
    hide()
  }

  public override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    if whistleWindow.keyWindow {
      setupFrames()
      hide()
    }
  }
}
