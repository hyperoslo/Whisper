import UIKit

public protocol NotificationControllerDelegate: class {
  func notificationControllerWillHide()
}

public class WhisperView: UIView {

  struct Dimensions {
    static let width: CGFloat = UIScreen.mainScreen().bounds.width
    static let height: CGFloat = 24
    static let offsetHeight: CGFloat = height * 2
    static let imageSize: CGFloat = 14
    static let loaderTitleOffset: CGFloat = 5
  }

  struct AnimationTiming {
    static let movement: NSTimeInterval = 0.3
    static let switcher: NSTimeInterval = 0.1
    static let popUp: NSTimeInterval = 1.5
    static let loaderDuration: NSTimeInterval = 0.7
    static let totalDelay: NSTimeInterval = popUp + movement * 2
  }

  public struct BaseColors {
    public static let neutral = "C8CBD1"
    public static let error = "FA2F5B"
    public static let warning = "FFCA00"
    public static let positive = "20D6B8"
  }

  lazy private(set) var transformViews: [UIView] = [self.titleLabel, self.complementImageView]

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .Center
    label.textColor = UIColor.whiteColor()
    label.font = UIFont(name: "HelveticaNeue", size: 13)
    label.frame.size.width = UIScreen.mainScreen().bounds.width - 60

    return label
    }()

  lazy var complementImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFill

    return imageView
    }()

  public weak var delegate: NotificationControllerDelegate?
  public var height: CGFloat
  var whisperImages: [UIImage]?
  var showTimer = NSTimer()

  // MARK: - Initializers

  init(height: CGFloat, message: Message) {
    self.height = height
    self.whisperImages = message.images
    super.init(frame: CGRectZero)

    titleLabel.text = message.title
    backgroundColor = message.color

    if let images = whisperImages where images.count > 1 {
      complementImageView.animationImages = images
      complementImageView.animationDuration = AnimationTiming.loaderDuration
      complementImageView.startAnimating()
    } else {
      complementImageView.image = whisperImages?.first
    }

    frame = CGRectMake(0, 0, Dimensions.width, Dimensions.height)
    for subview in transformViews { addSubview(subview) }

    titleLabel.sizeToFit()
    setupFrames()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Timer Methods

  func delayFired(timer: NSTimer) {
    delegate?.notificationControllerWillHide()
    //removeView()
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
        x: titleLabel.frame.origin.y - Dimensions.imageSize - Dimensions.loaderTitleOffset,
        y: (frame.height - Dimensions.imageSize) / 2,
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
