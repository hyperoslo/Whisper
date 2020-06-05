import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var navigationController: UINavigationController = UINavigationController(rootViewController: ViewController())

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}

