import UIKit

public enum WhistleAction {
  case present
  case show(TimeInterval)
}

let whistleFactory = WhistleFactory()

open class WhistleFactory: UIViewController {

  open lazy var whistleWindow: UIWindow = UIWindow()

  public struct Dimensions {

    static var notchHeight: CGFloat {
      if UIApplication.shared.statusBarFrame.height > 20 {
        return 32.0
      } else {
        return 0.0
      }
    }
  }

  open lazy var titleLabelHeight = CGFloat(20.0)

  open lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center

    return label
  }()
    
  open fileprivate(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
      let gesture = UITapGestureRecognizer()
      gesture.addTarget(self, action: #selector(WhistleFactory.handleTapGestureRecognizer))
        
      return gesture
  }()

  open fileprivate(set) var murmur: Murmur?
  open var viewController: UIViewController?
  open var hideTimer = Timer()

  private weak var previousKeyWindow: UIWindow?

  // MARK: - Initializers

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)

    setupWindow()
    view.clipsToBounds = true
    view.addSubview(titleLabel)
    
    view.addGestureRecognizer(tapGestureRecognizer)

    NotificationCenter.default.addObserver(self, selector: #selector(WhistleFactory.orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
  }

  // MARK: - Configuration

  open func whistler(_ murmur: Murmur, action: WhistleAction) {
    self.murmur = murmur
    titleLabel.text = murmur.title
    titleLabel.font = murmur.font
    titleLabel.textColor = murmur.titleColor
    view.backgroundColor = murmur.backgroundColor
    whistleWindow.backgroundColor = murmur.backgroundColor

    moveWindowToFront()
    setupFrames()

    switch action {
    case .show(let duration):
      show(duration: duration)
    default:
      present()
    }
  }

  // MARK: - Setup

  open func setupWindow() {
    whistleWindow.addSubview(self.view)
    whistleWindow.clipsToBounds = true
    moveWindowToFront()
  }

  func moveWindowToFront() {
    whistleWindow.windowLevel = view.isiPhoneX ? UIWindow.Level.normal : UIWindow.Level.statusBar
    setNeedsStatusBarAppearanceUpdate()
  }

  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIApplication.shared.statusBarStyle
  }

  open func setupFrames() {
    whistleWindow = UIWindow()

    setupWindow()

    let labelWidth = UIScreen.main.bounds.width
    let defaultHeight = titleLabelHeight

    if let text = titleLabel.text {
      let neededDimensions =
        NSString(string: text).boundingRect(
          with: CGSize(width: labelWidth, height: CGFloat.infinity),
          options: NSStringDrawingOptions.usesLineFragmentOrigin,
          attributes: [NSAttributedString.Key.font: titleLabel.font],
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

    whistleWindow.frame = CGRect(x: 0, y: 0,
                                 width: labelWidth,
                                 height: titleLabelHeight + Dimensions.notchHeight)
    view.frame = whistleWindow.bounds

    titleLabel.frame = CGRect(
        x: 0.0,
        y: Dimensions.notchHeight,
        width: view.bounds.width,
        height: titleLabelHeight
    )
  }

  // MARK: - Movement methods

  public func show(duration: TimeInterval) {
    present()
    calm(after: duration)
  }

  public func present() {
    hideTimer.invalidate()

    if UIApplication.shared.keyWindow != whistleWindow {
      previousKeyWindow = UIApplication.shared.keyWindow
    }

    let initialOrigin = whistleWindow.frame.origin.y
    whistleWindow.frame.origin.y = initialOrigin - titleLabelHeight - Dimensions.notchHeight
    whistleWindow.isHidden = false
    UIView.animate(withDuration: 0.2, animations: {
      self.whistleWindow.frame.origin.y = initialOrigin
    })
  }

  public func hide() {
    let finalOrigin = view.frame.origin.y - titleLabelHeight - Dimensions.notchHeight
    UIView.animate(withDuration: 0.2, animations: {
      self.whistleWindow.frame.origin.y = finalOrigin
      }, completion: { _ in
        if let window = self.previousKeyWindow {
          window.isHidden = false
          self.whistleWindow.windowLevel = UIWindow.Level.normal - 1
          self.previousKeyWindow = nil
          window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    })
  }

  public func calm(after: TimeInterval) {
    hideTimer.invalidate()
    hideTimer = Timer.scheduledTimer(timeInterval: after, target: self, selector: #selector(WhistleFactory.timerDidFire), userInfo: nil, repeats: false)
  }

  // MARK: - Timer methods

    @objc public func timerDidFire() {
    hide()
  }

    @objc func orientationDidChange() {
    if whistleWindow.isKeyWindow {
      setupFrames()
      hide()
    }
  }
    
  // MARK: - Gesture methods
    
  @objc fileprivate func handleTapGestureRecognizer() {
      guard let murmur = murmur else { return }
      murmur.action?()
  }
}
