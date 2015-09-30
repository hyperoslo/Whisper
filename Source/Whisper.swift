import UIKit
import Foundation

public func Whisper(message: Message, navigationController: UINavigationController, action: Whisperx.Action = .Show) {
  // TODO: Create the whisper view.
  // TODO: Add it to the navigationController view.
  // TODO: Present it or show it depending on the action.
}

public class Whisperx: NSObject {

  public struct Notifications {
    public static let present = "Whisper.PresentNotification"
    public static let show = "Whisper.ShowNotification"
    public static let change = "Whisper.ChangeNotification"
    public static let hide = "Whisper.HideNotification"
  }

  public enum Action: String {
    case Present = "Whisper.PresentNotification"
    case Show = "Whisper.ShowNotification"
  }

  var navigationController: UINavigationController
  var edgeInsetHeight: CGFloat = 0
  var customLoader: [UIImage] = []
  var customImage: UIImageView = UIImageView()

  lazy var notificationController: NotificationController = { [unowned self] in
    let notificationController = NotificationController(
      height: self.navigationController.navigationBar.frame.height)
    return notificationController
    }()

  public var isAvailable: Bool {
    return navigationController.navigationBar.frame.height != 0
      && !navigationController.navigationBarHidden
  }

  // MARK: - Initializers

  public init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init()

    self.navigationController.delegate = self
    notificationController.delegate = self
    notificationController.loaderImages = customLoader
    notificationController.complementImageView = customImage
    navigationController.navigationBar.addSubview(notificationController.view)

    setupNotifications()
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  // MARK: - Animations

  func moveViews(down: Bool) {
    edgeInsetHeight = down ? NotificationController.Dimensions.height : 0

    UIView.animateWithDuration(NotificationController.AnimationTiming.movement,
      animations: { [unowned self] in
        self.viewToMove(self.navigationController.visibleViewController!)
      })
  }

  func viewToMove(viewController: UIViewController) {
    if let whisperMovable = viewController as? WhisperMovable {
      whisperMovable.whisperWillSetContentTop(edgeInsetHeight)
    } else if viewController is UITableViewController {
      let tableView = viewController.view as! UITableView
      tableView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
    } else if viewController is UICollectionViewController {
      let collectionView = viewController.view as! UICollectionView
      collectionView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
    } else {
      for view in viewController.view.subviews {
        if view is UIScrollView {
          let scrollView = view as! UIScrollView
          scrollView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
        }
      }
    }
  }

  // MARK: - Notifications setup

  func setupNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "presentNotification:", name: Notifications.present, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "showNotification:", name: Notifications.show, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "changeNotification:", name: Notifications.change, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "hideNotification:", name: Notifications.hide, object: nil)
  }
}

// MARK: - Whisperable

extension Whisperx: Whisperable {

  public func present(notification: Notification) {
    if isAvailable {
      notificationController.present(notification)
      moveViews(true)
    }
  }

  public func show(notification: Notification) {
    if isAvailable {
      notificationController.show(notification)
      moveViews(true)
    }
  }

  public func change(notification: Notification) {
    if isAvailable {
      notificationController.change(notification)
    }
  }

  public func hide() {
    if isAvailable {
      notificationController.hide()
      moveViews(false)
    }
  }
}

// MARK: - NSNotifications

extension Whisperx {

  func presentNotification(notification: NSNotification) {
    if let notification = notification.object as? Notification {
      present(notification)
    }
  }

  func showNotification(notification: NSNotification) {
    if let notification = notification.object as? Notification {
      show(notification)
    }
  }

  func changeNotification(notification: NSNotification) {
    if let notification = notification.object as? Notification {
      change(notification)
    }
  }

  func hideNotification(notification: NSNotification) {
    hide()
  }
}

// MARK: - NotificationControllerDelegate

extension Whisperx: NotificationControllerDelegate {

  public func notificationControllerWillHide() {
    moveViews(false)
  }
}

// MARK: UINavigationControllerDelegate

extension Whisperx: UINavigationControllerDelegate {

  public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    viewToMove(viewController)
  }
}
