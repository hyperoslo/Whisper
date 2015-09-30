import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var navigationController: UINavigationController = {
    let navigationController = UINavigationController(rootViewController: ViewController())
    
    return navigationController
    }()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    return true
  }
}

