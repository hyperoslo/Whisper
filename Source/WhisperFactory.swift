import UIKit

public enum Action: String {
  case Present = "Whisper.PresentNotification"
  case Show = "Whisper.ShowNotification"
}

public func Whisper(message: Message, to: UINavigationController, action: Action = .Show) {
  WhisperFactory.craft(message, navigationController: to, action: action)
}

public func Silent(controller: UINavigationController, after: NSTimeInterval = 0) {
  WhisperFactory.silentWhisper(controller, after: after)
}

class WhisperFactory: NSObject {

  struct AnimationTiming {
    static let movement: NSTimeInterval = 0.3
    static let switcher: NSTimeInterval = 0.1
    static let popUp: NSTimeInterval = 1.5
    static let loaderDuration: NSTimeInterval = 0.7
    static let totalDelay: NSTimeInterval = popUp + movement * 2
  }

  static var navigationController = UINavigationController()
  static var edgeInsetHeight: CGFloat = 0
  static var whisperView: WhisperView!
  static var delayTimer = NSTimer()

  static func craft(message: Message, navigationController: UINavigationController, action: Action) {
    self.navigationController = navigationController

    var containsWhisper = false
    for subview in navigationController.navigationBar.subviews {
      if subview.classForCoder == WhisperView.classForCoder() {
        containsWhisper = true
        break
      }
    }

    if !containsWhisper {
      whisperView = WhisperView(height: navigationController.navigationBar.frame.height, message: message)
      whisperView.frame.size.height = 0
      for subview in whisperView.transformViews { subview.frame.origin.y = -20 }
      navigationController.navigationBar.addSubview(whisperView)
    }

    if containsWhisper {
      changeView(message, action: action)
    } else {
      switch action {
      case .Present:
        presentView()
      case .Show:
        showView()
      }
    }
  }

  static func silentWhisper(controller: UINavigationController, after: NSTimeInterval) {
    navigationController = controller

    for subview in navigationController.navigationBar.subviews {
      if let whisper = subview as? WhisperView {
        whisperView = whisper
        break
      }
    }

    delayTimer.invalidate()
    delayTimer = NSTimer.scheduledTimerWithTimeInterval(after, target: self,
      selector: "delayFired:", userInfo: nil, repeats: false)
  }

  // MARK: - Presentation

  static func presentView() {
    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      self.whisperView.frame.size.height = WhisperView.Dimensions.height
      for subview in self.whisperView.transformViews { subview.frame.origin.y = 0 }
    })
  }

  static func showView() {
    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      self.whisperView.frame.size.height = WhisperView.Dimensions.height
      for subview in self.whisperView.transformViews { subview.frame.origin.y = 0 }
      }, completion: { _ in
        delayTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self,
          selector: "delayFired:", userInfo: nil, repeats: false)
    })
  }

  static func changeView(message: Message, action: Action) {
    delayTimer.invalidate()
    hideView()
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(AnimationTiming.movement * 1.5 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      whisperView = WhisperView(height: navigationController.navigationBar.frame.height, message: message)
      navigationController.navigationBar.addSubview(whisperView)
      whisperView.frame.size.height = 0

      presentView()
    }
  }

  static func hideView() {
    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      self.whisperView.frame.size.height = 0
      for subview in self.whisperView.transformViews { subview.frame.origin.y = -20 }
      }, completion: { _ in
        self.whisperView.removeFromSuperview()
    })
  }

  // MARK: - Timer methods

  static func delayFired(timer: NSTimer) {
    hideView()
  }
}

//public class Whisperx: NSObject {
//
//  lazy var notificationController: NotificationController = { [unowned self] in
//    let notificationController = NotificationController(
//      height: self.navigationController.navigationBar.frame.height)
//    return notificationController
//    }()
//
//  public var isAvailable: Bool {
//    return navigationController.navigationBar.frame.height != 0
//      && !navigationController.navigationBarHidden
//  }
//
//  // MARK: - Initializers
//
//  public init(_ navigationController: UINavigationController) {
//    self.navigationController = navigationController
//    super.init()
//
//    self.navigationController.delegate = self
//    notificationController.delegate = self
//    notificationController.loaderImages = customLoader
//    notificationController.complementImageView = customImage
//    navigationController.navigationBar.addSubview(notificationController.view)
//
//    setupNotifications()
//  }
//
//  // MARK: - Animations
//
//  func moveViews(down: Bool) {
//    edgeInsetHeight = down ? NotificationController.Dimensions.height : 0
//
//    UIView.animateWithDuration(NotificationController.AnimationTiming.movement,
//      animations: { [unowned self] in
//        self.viewToMove(self.navigationController.visibleViewController!)
//      })
//  }
//
//  func viewToMove(viewController: UIViewController) {
//    if let whisperMovable = viewController as? WhisperMovable {
//      whisperMovable.whisperWillSetContentTop(edgeInsetHeight)
//    } else if viewController is UITableViewController {
//      let tableView = viewController.view as! UITableView
//      tableView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
//    } else if viewController is UICollectionViewController {
//      let collectionView = viewController.view as! UICollectionView
//      collectionView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
//    } else {
//      for view in viewController.view.subviews {
//        if view is UIScrollView {
//          let scrollView = view as! UIScrollView
//          scrollView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
//        }
//      }
//    }
//  }
//}
//
//// MARK: - Whisperable
//
//extension Whisperx {
//
//  public func present(notification: Notification) {
//    if isAvailable {
//      notificationController.present(notification)
//      moveViews(true)
//    }
//  }
//
//  public func show(notification: Notification) {
//    if isAvailable {
//      notificationController.show(notification)
//      moveViews(true)
//    }
//  }
//
//  public func hide() {
//    if isAvailable {
//      notificationController.hide()
//      moveViews(false)
//    }
//  }
//}
//
//// MARK: - NotificationControllerDelegate
//
//extension Whisperx: NotificationControllerDelegate {
//
//  public func notificationControllerWillHide() {
//    moveViews(false)
//  }
//}
//
//// MARK: UINavigationControllerDelegate
//
//extension UINavigationControllerDelegate {
//
//  public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//    viewToMove(viewController)
//  }
//}
