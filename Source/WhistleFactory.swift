import UIKit

let whitleFactory = WhistleFactory()

public func Whistle(murmur: Murmur) {
  whistleFactory.configureWhistle(murmur)
}

public class WhistleFactory: UIView {

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
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

  public func configureWhistle(murmur: Murmur) {
    titleLabel.text = murmur.title
    titleLabel.font = murmur.font
    titleLabel.textColor = murmur.titleColor
    backgroundColor = murmur.backgroundColor

    setupFrames()
  }

  // MARK: - Setup

  public func setupFrames() {
    titleLabel.sizeToFit()


  }

  // MARK: - Movement methods

  public func present() {

  }

  public func hide() {
    
  }
}
