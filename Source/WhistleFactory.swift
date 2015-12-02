import UIKit

let whistleFactory = WhistleFactory()

public func Whistle(murmur: Murmur, to: UIViewController) {
  whistleFactory.whistler(murmur, controller: to)
}

public class WhistleFactory: UIView {

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Center

    return label
    }()

  public lazy var blurView: UIVisualEffectView = {
    let view = UIVisualEffectView()
    return view
    }()

  public lazy var statusBarSnapshot: UIImageView = {
    let view = UIImageView()
    return view
    }()

  public var duration: NSTimeInterval = 2
  public var viewController: UIViewController?

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
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

    setupFrames()
    present()
  }

  // MARK: - Setup

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
    guard let controller = viewController else { return }

    if let navigationController = controller.navigationController
      where !navigationController.navigationBarHidden {
        navigationController.navigationBar.addSubview(self)
    } else {
      controller.view.addSubview(self)
    }

    window?.windowLevel = UIWindowLevelStatusBar + 1
  }

  public func hide() {
    
  }
}
