import UIKit
import Whisper

class ViewController: UIViewController {

  lazy var scrollView: UIScrollView = UIScrollView()

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

  lazy var presentButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: "presentButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Present", forState: .Normal)
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button.layer.borderColor = UIColor.blackColor().CGColor
    button.layer.borderWidth = 1.5
    button.layer.cornerRadius = 7.5

    return button
    }()

  var shouldChange = false

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Whisper".uppercaseString
    view.backgroundColor = UIColor.whiteColor()

    view.addSubview(scrollView)
    for subview in [icon, titleLabel, presentButton] { scrollView.addSubview(subview) }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    setupFrames()
  }

  // MARK: Action methods

  func presentButtonDidPress(button: UIButton) {
    guard let navigationController = self.navigationController else { return }
    let message = Message(title: "Sup", color: UIColor.redColor())
    let secondMessage = Message(title: "Changing all the things", color: UIColor.blackColor())

    shouldChange
      ? Whisper(secondMessage, to: navigationController, action: .Present)
      : Whisper(message, to: navigationController, action: .Present)

    //    if shouldChange {
    //      Silent(navigationController, after: 3)
    //      let controller = ViewController()
    //      controller.view.backgroundColor = UIColor.redColor()
    //      navigationController.pushViewController(controller, animated: true)
    //    }

    shouldChange = !shouldChange
  }

  // MARK - Configuration

  func setupFrames() {
    guard let navigationHeight = navigationController?.navigationBar.frame.height else { return }
    let totalSize = UIScreen.mainScreen().bounds
    let originY = navigationHeight + UIApplication.sharedApplication().statusBarFrame.height

    scrollView.frame = CGRect(x: 0, y: originY,
      width: totalSize.width, height: totalSize.height - originY)
    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: totalSize.height / 2 - 150)
    presentButton.frame = CGRect(x: 50, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 75,
      width: totalSize.width - 100, height: 50)
  }
}

