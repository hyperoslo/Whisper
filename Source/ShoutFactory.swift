import UIKit

public func Shout(announcement: Announcement, to: UIViewController) {
  
}

public class ShoutView: UIView {

  public lazy var backgroundView: UIView = {
    let view = UIView()
    return view
    }()

  public lazy var blurView: UIVisualEffectView = {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    return blurView
    }()

  public lazy var indicatorView: UIView = {
    let view = UIView()
    return view
    }()

  public lazy var gestureContainer: UIView = {
    let view = UIView()
    return view
    }()

  public lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
    }()

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    return label
    }()

  public lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    return label
    }()

  public lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: "handleTapGestureRecognizer")
    return gesture
    }()

  public lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
    let gesture = UIPanGestureRecognizer()
    gesture.addTarget(self, action: "handlePanGestureRecognizer")

    return gesture
    }()

  public var announcement: Announcement

  // MARK: - Initializers

  public init(announcement: Announcement) {
    self.announcement = announcement
    super.init(frame: CGRectZero)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Gesture methods

  public func handleTapGestureRecognizer() {
    announcement.action?()
  }

  public func handlePanGestureRecognizer() {

  }
}
