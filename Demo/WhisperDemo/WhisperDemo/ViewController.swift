import UIKit

class ViewController: UIViewController {

  lazy var icon: UIImageView = {
    let imageView = UIImageView()
    return imageView
    }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Welcome to the magic of a tiny Whisper... 🍃"
    label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)!
    label.textColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1)
    label.textAlignment = .Center
    label.numberOfLines = 0
    label.frame.size.width = UIScreen.mainScreen().bounds.width - 60
    label.sizeToFit()

    return label
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Whisper".uppercaseString
    view.backgroundColor = UIColor.whiteColor()

    for subview in [icon, titleLabel] { view.addSubview(subview) }

    setupFrames()
  }

  // MARK - Configuration

  func setupFrames() {
    let totalSize = UIScreen.mainScreen().bounds

    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: totalSize.height / 2)
  }
}

