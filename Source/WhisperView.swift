import UIKit

public protocol NotificationControllerDelegate: class {
  func notificationControllerWillHide()
}

open class WhisperView: UIView {

  public struct Dimensions {
    public static let height: CGFloat = 24
    static let offsetHeight: CGFloat = height * 2
    static let imageSize: CGFloat = 14
    static let loaderTitleOffset: CGFloat = 5
  }

  lazy fileprivate(set) var transformViews: [UIView] = [self.titleLabel, self.complementImageView]

  open lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont(name: "HelveticaNeue", size: 13)
    label.frame.size.width = UIScreen.main.bounds.width - 60

    return label
    }()

  lazy var complementImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill

    return imageView
    }()

  open weak var delegate: NotificationControllerDelegate?
  open var height: CGFloat
  var whisperImages: [UIImage]?

  // MARK: - Initializers

  init(height: CGFloat, message: Message) {
    self.height = height
    self.whisperImages = message.images
    super.init(frame: CGRect.zero)

    titleLabel.text = message.title
    titleLabel.textColor = message.textColor
    backgroundColor = message.backgroundColor

    if let images = whisperImages , images.count > 1 {
      complementImageView.animationImages = images
      complementImageView.animationDuration = 0.7
      complementImageView.startAnimating()
    } else {
      complementImageView.image = whisperImages?.first
    }

    frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: Dimensions.height)
    for subview in transformViews { addSubview(subview) }

    titleLabel.sizeToFit()
    setupFrames()
    clipsToBounds = true
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout

extension WhisperView {

  func setupFrames() {
    if whisperImages != nil {
      titleLabel.frame = CGRect(
        x: (frame.width - titleLabel.frame.width) / 2 + 20,
        y: 0,
        width: titleLabel.frame.width,
        height: frame.height)

      complementImageView.frame = CGRect(
        x: titleLabel.frame.origin.x - Dimensions.imageSize - Dimensions.loaderTitleOffset,
        y: (Dimensions.height - Dimensions.imageSize) / 2,
        width: Dimensions.imageSize,
        height: Dimensions.imageSize)
    } else {
      titleLabel.frame = CGRect(
        x: (frame.width - titleLabel.frame.width) / 2,
        y: 0,
        width: titleLabel.frame.width,
        height: frame.height)
    }
  }
}
