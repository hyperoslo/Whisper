import UIKit

let whistleFactory = WhistleFactory()

public func Whistle(murmur: Murmur) {
  whistleFactory.whistler(murmur)
}

public class WhistleFactory: UIViewController {

  public lazy var whistleWindow: UIWindow = UIWindow()
    
    public lazy var titleLabelHeight = CGFloat(20.0)

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

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  // MARK: - Configuration

  public func whistler(murmur: Murmur) {
    titleLabel.text = murmur.title
    titleLabel.font = murmur.font
    titleLabel.textColor = murmur.titleColor
    view.backgroundColor = murmur.backgroundColor
    whistleWindow.backgroundColor = murmur.backgroundColor

    moveWindowToFront()
    setupFrames()
    present(duration: murmur.duration)
  }

  // MARK: - Setup

  public func setupWindow() {
    whistleWindow.addSubview(self.view)
    whistleWindow.clipsToBounds = true
    moveWindowToFront()
  }
  
  func moveWindowToFront() {
    let currentStatusBarStyle = UIApplication.sharedApplication().statusBarStyle
    whistleWindow.windowLevel = UIWindowLevelStatusBar
    UIApplication.sharedApplication().setStatusBarStyle(currentStatusBarStyle, animated: false)
  }

  public func setupFrames() {
    let labelWidth = UIScreen.mainScreen().bounds.width
    let defaultHeight = titleLabelHeight
    
    if let text = titleLabel.text {
      let neededDimensions =
        NSString(string: text).boundingRectWithSize(
          CGSize(width: labelWidth, height: CGFloat.infinity),
          options: NSStringDrawingOptions.UsesLineFragmentOrigin,
          attributes: [NSFontAttributeName: titleLabel.font],
          context: nil
        )
      titleLabelHeight = CGFloat(neededDimensions.size.height)
      titleLabel.numberOfLines = 0 // Allows unwrapping
      
      if titleLabelHeight < defaultHeight {
        titleLabelHeight = defaultHeight
      }
    } else {
      titleLabel.sizeToFit()
    }

    whistleWindow.frame = CGRect(x: 0, y: 0, width: labelWidth,
      height: titleLabelHeight)
    view.frame = whistleWindow.bounds
    titleLabel.frame = view.bounds
  }

  // MARK: - Movement methods

  public func present(duration duration: NSTimeInterval) {
    hideTimer.invalidate()

    let initialOrigin = whistleWindow.frame.origin.y
    whistleWindow.frame.origin.y = initialOrigin - titleLabelHeight
    whistleWindow.makeKeyAndVisible()
    UIView.animateWithDuration(0.2, animations: {
      self.whistleWindow.frame.origin.y = initialOrigin
    })

    hideTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "timerDidFire", userInfo: nil, repeats: false)
  }

  public func hide() {
    let finalOrigin = view.frame.origin.y - titleLabelHeight
    UIView.animateWithDuration(0.2, animations: {
      self.whistleWindow.frame.origin.y = finalOrigin
      }, completion: { _ in
        if let window = UIApplication.sharedApplication().windows.filter({ $0 != self.whistleWindow }).first {
          window.makeKeyAndVisible()
          self.whistleWindow.windowLevel = UIWindowLevelNormal - 1
          window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    })
  }
 
  // MARK: - Timer methods

  public func timerDidFire() {
    hide()
  }

  func orientationDidChange() {
    if whistleWindow.keyWindow {
      setupFrames()
      hide()
    }
  }
}
