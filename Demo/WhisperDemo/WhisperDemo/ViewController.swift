import UIKit
import Whisper

extension UINavigationController {
  public override func whisperYPosition(direction: Direction) -> CGFloat {
    if direction == .Down{
      return CGRectGetMaxY(self.navigationBar.frame);
    }else{
      return CGRectGetMaxY(self.view.frame);
    }
  }
}

class ViewController: UIViewController {
  
  static var direction : Direction = .Down
  
  // MARK: contentInset methods
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "whisperWillAppear:", name:WhisperNotifications.willAppearNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "whisperWillDisappear:", name:WhisperNotifications.willDisappearNotification, object: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func whisperWillAppear(notification: NSNotification?) {
    guard let duration = notification?.userInfo?["duration"] as? NSTimeInterval,
      whisperView = self.navigationController?.whisper else { return }
    self.animateInsetChange(duration, height: whisperView.calculatedHeight(), direction: whisperView.direction)
  }
  
  func whisperWillDisappear(notification: NSNotification?) {
    guard let duration = notification?.userInfo?["duration"] as? NSTimeInterval,
    whisperView = self.navigationController?.whisper else { return }
    self.animateInsetChange(duration, height: 0, direction: whisperView.direction)
  }
  
  func animateInsetChange(duration: NSTimeInterval, height: CGFloat, direction: Direction) {
    UIView.animateWithDuration(duration, animations: {
      var inset = self.scrollView.contentInset
      if (direction == .Down){
        inset.top = self.topLayoutGuide.length + height
      }else if (direction == .Up){
        inset.bottom = self.bottomLayoutGuide.length + height
      }
      self.scrollView.contentInset = inset
    })
  }
  
  // MARK: UI

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
    button.addTarget(self, action: "presentButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Present and silent", forState: .Normal)

    return button
    }()
  
  lazy var presentBottomButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "presentBottomButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Present at the bottom and silent", forState: .Normal)
    button.titleLabel?.numberOfLines = 2
    button.titleLabel?.textAlignment = .Center
    
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

  lazy var nextButton: UIBarButtonItem = { [unowned self] in
    let button = UIBarButtonItem()
    button.title = "Next"
    button.style = .Plain
    button.target = self
    button.action = "nextButtonDidPress"

    return button
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()
    title = "Whisper".uppercaseString
    navigationItem.rightBarButtonItem = nextButton

    view.addSubview(scrollView)
    [titleLabel, presentButton, presentBottomButton, showButton,
      presentPermanentButton, notificationButton, statusBarButton].forEach { scrollView.addSubview($0) }

    [presentButton, presentBottomButton, showButton, presentPermanentButton, notificationButton, statusBarButton].forEach {
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
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.setupFrames()
  }

  // MARK: Action methods

  func presentButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }
    let message = Message(title: "This message will silent in 3 seconds.", backgroundColor: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))

    Whisper(message, to: navigationController, action: .Present)
    Silent(navigationController, after: 3)
  }
  
  func presentBottomButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }
    let message = Message(title: "Bottom message that will silent in 3 seconds.", backgroundColor: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))
    
    Whisper(message, to: navigationController, action: .Present, direction: .Up)
    Silent(navigationController, after: 3)
  }

  func showButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "Showing all the things.", backgroundColor: UIColor.blackColor())
    Whisper(message, to: navigationController)
  }

  func presentPermanentButtonDidPress(button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "This is a permanent Whisper.", textColor: UIColor(red:0.87, green:0.34, blue:0.05, alpha:1),
      backgroundColor: UIColor(red:1.000, green:0.973, blue:0.733, alpha: 1))
    Whisper(message, to: navigationController, action: .Present)
  }

  func presentNotificationDidPress(button: UIButton) {
    let announcement = Announcement(title: "Ramon Gilabert", subtitle: "Vadym Markov just commented your post", image: UIImage(named: "avatar"))

    Shout(announcement, to: self, completion: {
      print("The shout was silent.")
    })
  }

  func nextButtonDidPress() {
    let controller = TableViewController()
    navigationController?.pushViewController(controller, animated: true)
  }

  func statusBarButtonDidPress(button: UIButton) {
    let murmur = Murmur(title: "This is a small whistle...",
      backgroundColor: UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1))

    Whistle(murmur)
  }

  // MARK - Configuration

  func setupFrames() {
    let totalSize = UIScreen.mainScreen().bounds

    scrollView.frame = CGRect(x: 0, y: 0, width: totalSize.width, height: totalSize.height)
    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: 60)
    presentButton.frame = CGRect(x: 50, y: titleLabel.frame.maxY + 75, width: totalSize.width - 100, height: 50)
    presentBottomButton.frame = CGRect(x: 50, y: presentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    showButton.frame = CGRect(x: 50, y: presentBottomButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    presentPermanentButton.frame = CGRect(x: 50, y: showButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    notificationButton.frame = CGRect(x: 50, y: presentPermanentButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
    statusBarButton.frame = CGRect(x: 50, y: notificationButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)

    let height = statusBarButton.frame.maxY >= totalSize.height ? statusBarButton.frame.maxY + 35 : totalSize.height
    scrollView.contentSize = CGSize(width: totalSize.width, height: height)
  }
}

