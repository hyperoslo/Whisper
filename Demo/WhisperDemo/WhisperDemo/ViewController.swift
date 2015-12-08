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

  lazy var notificationButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "presentNotificationDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Notification", forState: .Normal)

    return button
    }()

  lazy var statusBarButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "statusBarButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Status bar", forState: .Normal)

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

    view.addSubview(scrollView)
    [icon, titleLabel, presentButton, showButton,
      presentPermanentButton, notificationButton, statusBarButton].forEach { scrollView.addSubview($0) }

    [presentButton, showButton, presentPermanentButton, notificationButton, statusBarButton].forEach {
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

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    title = "Whisper".uppercaseString
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
    let message = Message(title: "This message will silent in 3 seconds.", color: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))

    Whisper(message, to: navigationController, action: .Present)
    Silent(navigationController, after: 3)
  }

  func showButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "Showing all the things.", color: UIColor.blackColor())
    Whisper(message, to: navigationController)
  }

  func presentPermanentButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "This is a permanent Whisper.", color: UIColor(red:0.87, green:0.34, blue:0.05, alpha:1))
    Whisper(message, to: navigationController, action: .Present)
  }

  func presentNotificationDidPress(button: UIButton) {
    let announcement = Announcement(title: "Ramon Gilabert", subtitle: "Vadym Markov just commented your post", image: UIImage(named: "avatar"))

    Shout(announcement, to: self)
  }

  func statusBarButtonDidPress(button: UIButton) {
    let murmur = Murmur(title: "This is a small whistle",
      backgroundColor: UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1))

    Whistle(murmur)
  }

  // MARK - Configuration

  func setupFrames() {
    let totalSize = UIScreen.mainScreen().bounds

    UIView.animateWithDuration(0.3, animations: {
      self.scrollView.frame = CGRect(x: 0, y: 0, width: totalSize.width, height: totalSize.height)
      self.titleLabel.frame.origin = CGPoint(x: (totalSize.width - self.titleLabel.frame.width) / 2, y: 60)
      self.presentButton.frame = CGRect(x: 50, y: self.titleLabel.frame.maxY + 75, width: totalSize.width - 100, height: 50)
      self.showButton.frame = CGRect(x: 50, y: self.presentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
      self.presentPermanentButton.frame = CGRect(x: 50, y: self.showButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
      self.notificationButton.frame = CGRect(x: 50, y: self.presentPermanentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
      self.statusBarButton.frame = CGRect(x: 50, y: self.notificationButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)

      let height = self.statusBarButton.frame.maxY >= totalSize.height ? self.statusBarButton.frame.maxY + 35 : totalSize.height
      self.scrollView.contentSize = CGSize(width: totalSize.width, height: height)
    })
  }
}

