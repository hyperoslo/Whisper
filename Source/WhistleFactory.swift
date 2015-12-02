import UIKit

let whistleFactory = WhistleFactory()

public func Whistle(murmur: Murmur) {
  whistleFactory.whistler(murmur)
}

public class WhistleFactory: UIView {

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Center

    return label
    }()

  public var duration: NSTimeInterval = 2

  // MARK: - Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
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

    setupFrames()
    present()
  }

  // MARK: - Setup

  public func setupFrames() {
    let barFrame = UIApplication.sharedApplication().statusBarFrame

    titleLabel.sizeToFit()

    frame = CGRect(x: 0, y: 0, width: barFrame.width, height: barFrame.height)
    titleLabel.frame = bounds
  }

  // MARK: - Movement methods

  public func present() {
    addSubview(titleLabel)
  }

  public func hide() {
    
  }
}
