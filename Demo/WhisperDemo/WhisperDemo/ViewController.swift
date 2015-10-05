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

  lazy var presentButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "presentButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Present and silent", forState: .Normal)

    return button
    }()

  lazy var showButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "showButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Show", forState: .Normal)

    return button
    }()

  lazy var presentPermanentButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "presentPermanentButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Present permanent Whisper", forState: .Normal)

    return button
    }()

  lazy var newControllerButton: UIBarButtonItem = { [unowned self] in
    let button = UIBarButtonItem()
    button.title = "Next"
    button.target = self
    button.action = "nextButtonDidPress"

    return button
    }()

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.grayColor()

    return view
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()

    navigationItem.rightBarButtonItem = newControllerButton
    navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)

    view.addSubview(scrollView)
    for subview in [icon, titleLabel, presentButton, showButton, presentPermanentButton] { scrollView.addSubview(subview) }

    for button in [presentButton, showButton, presentPermanentButton] {
      button.setTitleColor(UIColor.grayColor(), forState: .Normal)
      button.layer.borderColor = UIColor.grayColor().CGColor
      button.layer.borderWidth = 1.5
      button.layer.cornerRadius = 7.5
    }

    guard let navigationController = navigationController else { return }

    navigationController.navigationBar.addSubview(containerView)
    containerView.frame = CGRect(x: 0,
      y: navigationController.navigationBar.frame.maxY - UIApplication.sharedApplication().statusBarFrame.height,
      width: UIScreen.mainScreen().bounds.width, height: 100)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    title = "Whisper".uppercaseString
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    setupFrames()
  }

  // MARK: Action methods

  func presentButtonDidPress(button: UIButton) {
    guard let navigationController = self.navigationController else { return }
    let message = Message(title: "This message will silent in 3 seconds.", color: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))

    Whisper(message, to: navigationController, action: .Present)
    Silent(navigationController, after: 3)
  }

  func showButtonDidPress(button: UIButton) {
    guard let navigationController = self.navigationController else { return }

    let message = Message(title: "Showing all the things.", color: UIColor.blackColor())
    Whisper(message, to: navigationController)
  }

  func presentPermanentButtonDidPress(button: UIButton) {
    guard let navigationController = self.navigationController else { return }

    let message = Message(title: "This is a permanent Whisper.", color: UIColor(red:0.87, green:0.34, blue:0.05, alpha:1))
    Whisper(message, to: navigationController, action: .Present)
  }

  func nextButtonDidPress() {
    let controller = DetailViewController()
    title = ""
    navigationController?.pushViewController(controller, animated: true)
  }

  // MARK - Configuration

  func setupFrames() {
    guard let navigationHeight = navigationController?.navigationBar.frame.height else { return }
    let totalSize = UIScreen.mainScreen().bounds
    let originY = navigationHeight + UIApplication.sharedApplication().statusBarFrame.height

    scrollView.frame = CGRect(x: 0, y: originY, width: totalSize.width, height: totalSize.height - originY)
    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: totalSize.height / 2 - 200)
    presentButton.frame = CGRect(x: 50, y: titleLabel.frame.maxY + 75, width: totalSize.width - 100, height: 50)
    showButton.frame = CGRect(x: 50, y: presentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    presentPermanentButton.frame = CGRect(x: 50, y: showButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
  }
}

