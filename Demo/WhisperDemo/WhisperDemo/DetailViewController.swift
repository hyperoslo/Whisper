import UIKit

class DetailViewController: UIViewController {

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.grayColor()

    return view
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1)
    title = "Whisper detail".uppercaseString

    guard let navigationController = navigationController else { return }

    navigationController.navigationBar.addSubview(containerView)
    containerView.frame = CGRect(x: 0,
      y: navigationController.navigationBar.frame.maxY - UIApplication.sharedApplication().statusBarFrame.height,
      width: UIScreen.mainScreen().bounds.width, height: 100)
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    containerView.removeFromSuperview()
  }
}
