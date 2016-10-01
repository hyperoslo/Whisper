import UIKit
import Whisper

class ViewController: UIViewController {

  lazy var scrollView: UIScrollView = UIScrollView()

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
    button.addTarget(self, action: #selector(presentButtonDidPress(_:)), forControlEvents: .TouchUpInside)
    button.setTitle("Present and silent", forState: .Normal)

    return button
    }()

  lazy var showButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(showButtonDidPress(_:)), forControlEvents: .TouchUpInside)
    button.setTitle("Show", forState: .Normal)

    return button
    }()

  lazy var presentPermanentButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentPermanentButtonDidPress(_:)), forControlEvents: .TouchUpInside)
    button.setTitle("Present permanent Whisper", forState: .Normal)

    return button
    }()

  lazy var notificationButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentNotificationDidPress(_:)), forControlEvents: .TouchUpInside)
    button.setTitle("Notification", forState: .Normal)

    return button
    }()

  lazy var showWhistleButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(showWhistleButtonDidPress(_:)), forControlEvents: .TouchUpInside)
    button.setTitle("Show Whistle", forState: .Normal)

    return button
    }()

  lazy var presentWhistleButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentWhistleButtonDidPress(_:)), forControlEvents: .TouchUpInside)
    button.setTitle("Present permanent Whistle", forState: .Normal)

    return button
    }()

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.grayColor()

    return view
    }()

  lazy var nextButton: UIBarButtonItem = { [unowned self] in
    let button = UIBarButtonItem()
    button.title = "Next"
    button.style = .Plain
    button.target = self
    button.action = #selector(nextButtonDidPress)

    return button
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()
    title = "Whisper".uppercaseString
    navigationItem.rightBarButtonItem = nextButton

    view.addSubview(scrollView)
    [titleLabel, presentButton, showButton,
      presentPermanentButton, notificationButton,
      showWhistleButton, presentWhistleButton].forEach { scrollView.addSubview($0) }

    [presentButton, showButton, presentPermanentButton,
      notificationButton, showWhistleButton, presentWhistleButton].forEach {
        $0.setTitleColor(UIColor.grayColor(), forState: .Normal)
        $0.layer.borderColor = UIColor.grayColor().CGColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 7.5
    }

    guard let navigationController = navigationController else { return }

    navigationController.navigationBar.addSubview(containerView)
    containerView.frame = CGRect(x: 0,
      y: navigationController.navigationBar.frame.maxY - UIApplication.sharedApplication().statusBarFrame.height,
      width: UIScreen.mainScreen().bounds.width, height: 0)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    setupFrames()
  }

  // MARK: - Orientation changes

  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    setupFrames()
  }

  // MARK: Action methods

  func presentButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }
    let message = Message(title: "This message will silent in 3 seconds.", backgroundColor: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))

    show(whisper: message, to: navigationController, action: .Present)
    hide(whisperFrom: navigationController, after: 3)
  }

  func showButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "Showing all the things.", backgroundColor: UIColor.blackColor())
    show(whisper: message, to: navigationController)
  }

  func presentPermanentButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "This is a permanent Whisper.", textColor: UIColor(red:0.87, green:0.34, blue:0.05, alpha:1),
      backgroundColor: UIColor(red:1.000, green:0.973, blue:0.733, alpha: 1))
    show(whisper: message, to: navigationController, action: .Present)
  }

  func presentNotificationDidPress(button: UIButton) {
    let announcement = Announcement(title: "Ramon Gilabert", subtitle: "Vadym Markov just commented your post", image: UIImage(named: "avatar"))

    if let navigationController = navigationController {
      show(shout: announcement, to: navigationController, completion: {
        print("The shout was silent.")
      })
    }
  }

  func nextButtonDidPress() {
    let controller = TableViewController()
    navigationController?.pushViewController(controller, animated: true)
  }

  func showWhistleButtonDidPress(button: UIButton) {
    let murmur = Murmur(title: "This is a small whistle...",
      backgroundColor: UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1))

    show(whistle: murmur)
  }

  func presentWhistleButtonDidPress(button: UIButton) {
    let murmur = Murmur(title: "This is a permanent whistle...",
                        backgroundColor: UIColor.redColor(),
                        titleColor: UIColor.whiteColor())

    show(whistle: murmur, action: .Present)
  }

  // MARK - Configuration

  func setupFrames() {
    let totalSize = UIScreen.mainScreen().bounds

    scrollView.frame = CGRect(x: 0, y: 0, width: totalSize.width, height: totalSize.height)
    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: 60)
    presentButton.frame = CGRect(x: 50, y: titleLabel.frame.maxY + 75, width: totalSize.width - 100, height: 50)
    showButton.frame = CGRect(x: 50, y: presentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    presentPermanentButton.frame = CGRect(x: 50, y: showButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    notificationButton.frame = CGRect(x: 50, y: presentPermanentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    showWhistleButton.frame = CGRect(x: 50, y: notificationButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    presentWhistleButton.frame = CGRect(x: 50, y: showWhistleButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)

    let height = presentWhistleButton.frame.maxY >= totalSize.height ? presentWhistleButton.frame.maxY + 35 : totalSize.height
    scrollView.contentSize = CGSize(width: totalSize.width, height: height)
  }
}

