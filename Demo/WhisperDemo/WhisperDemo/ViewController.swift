import UIKit
import Whisper

class ViewController: UIViewController {

  lazy var scrollView: UIScrollView = UIScrollView()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Welcome to the magic of a tiny Whisper... 🍃"
    label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)!
    label.textColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.frame.size.width = UIScreen.main.bounds.width - 60
    label.sizeToFit()

    return label
    }()

  lazy var presentButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentButtonDidPress(_:)), for: .touchUpInside)
    button.setTitle("Present and silent", for: UIControl.State())

    return button
    }()

  lazy var showButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(showButtonDidPress(_:)), for: .touchUpInside)
    button.setTitle("Show", for: UIControl.State())

    return button
    }()

  lazy var presentPermanentButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentPermanentButtonDidPress(_:)), for: .touchUpInside)
    button.setTitle("Present permanent Whisper", for: UIControl.State())

    return button
    }()

  lazy var notificationButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentNotificationDidPress(_:)), for: .touchUpInside)
    button.setTitle("Notification", for: UIControl.State())

    return button
    }()

  lazy var showWhistleButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(showWhistleButtonDidPress(_:)), for: .touchUpInside)
    button.setTitle("Show Whistle", for: UIControl.State())

    return button
    }()

  lazy var presentWhistleButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(presentWhistleButtonDidPress(_:)), for: .touchUpInside)
    button.setTitle("Present permanent Whistle", for: UIControl.State())

    return button
    }()

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.gray

    return view
    }()

  lazy var nextButton: UIBarButtonItem = { [unowned self] in
    let button = UIBarButtonItem()
    button.title = "Next"
    button.style = .plain
    button.target = self
    button.action = #selector(nextButtonDidPress)

    return button
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white
    title = "Whisper".uppercased()
    navigationItem.rightBarButtonItem = nextButton

    view.addSubview(scrollView)
    [titleLabel, presentButton, showButton,
      presentPermanentButton, notificationButton,
      showWhistleButton, presentWhistleButton].forEach { scrollView.addSubview($0) }

    [presentButton, showButton, presentPermanentButton,
      notificationButton, showWhistleButton, presentWhistleButton].forEach {
        $0.setTitleColor(UIColor.gray, for: UIControl.State())
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 7.5
    }

    guard let navigationController = navigationController else { return }

    navigationController.navigationBar.addSubview(containerView)
    containerView.frame = CGRect(x: 0,
      y: navigationController.navigationBar.frame.maxY - UIApplication.shared.statusBarFrame.height,
      width: UIScreen.main.bounds.width, height: 0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupFrames()
  }

  // MARK: - Orientation changes

  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    setupFrames()
  }

  // MARK: Action methods

  @objc func presentButtonDidPress(_ button: UIButton) {
    guard let navigationController = navigationController else { return }
    let message = Message(title: "This message will silent in 3 seconds.", backgroundColor: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))

    Whisper.show(whisper: message, to: navigationController, action: .present)
    hide(whisperFrom: navigationController, after: 3)
  }

  @objc func showButtonDidPress(_ button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "Showing all the things.", backgroundColor: UIColor.black)
    Whisper.show(whisper: message, to: navigationController)
  }

  @objc func presentPermanentButtonDidPress(_ button: UIButton) {
    guard let navigationController = navigationController else { return }

    let message = Message(title: "This is a permanent Whisper.", textColor: UIColor(red:0.87, green:0.34, blue:0.05, alpha:1),
      backgroundColor: UIColor(red:1.000, green:0.973, blue:0.733, alpha: 1))
    Whisper.show(whisper: message, to: navigationController, action: .present)
  }

  @objc func presentNotificationDidPress(_ button: UIButton) {
    let announcement = Announcement(title: "Ramon Gilabert", subtitle: "Vadym Markov just commented your post: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'", image: UIImage(named: "avatar"), duration: 30)

    if let navigationController = navigationController {
      Whisper.show(shout: announcement, to: navigationController, completion: {
        print("The shout was silent.")
      })
    }
  }

  @objc func nextButtonDidPress() {
    let controller = TableViewController()
    navigationController?.pushViewController(controller, animated: true)
  }

  @objc func showWhistleButtonDidPress(_ button: UIButton) {
    let murmur = Murmur(title: "This is a small whistle...",
      backgroundColor: UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1))

    Whisper.show(whistle: murmur)
  }

  @objc func presentWhistleButtonDidPress(_ button: UIButton) {
    let murmur = Murmur(title: "This is a permanent whistle...",
                        backgroundColor: UIColor.red,
                        titleColor: UIColor.white)

    Whisper.show(whistle: murmur, action: .present)
  }

  // MARK - Configuration

  func setupFrames() {
    let totalSize = UIScreen.main.bounds

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

