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
    //self.navigationController.delegate = WhisperFactory

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

  // MARK: - Navigation bar animations

  // MARK: - Animations

  static func moveControllerViews(down: Bool) {
    edgeInsetHeight = down ? WhisperView.Dimensions.height : 0

    UIView.animateWithDuration(AnimationTiming.movement, animations: {
        self.performControllerMove(self.navigationController.visibleViewController!)
      })
  }

  static func performControllerMove(viewController: UIViewController) {
    if viewController is UITableViewController {
      let tableView = viewController.view as! UITableView
      tableView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
    } else if viewController is UICollectionViewController {
      let collectionView = viewController.view as! UICollectionView
      collectionView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
    } else {
      for view in viewController.view.subviews {
        if let scrollView = view as? UIScrollView {
          scrollView.contentInset = UIEdgeInsetsMake(edgeInsetHeight, 0, 0, 0)
        }
      }
    }
  }
}

// MARK: UINavigationControllerDelegate

extension WhisperFactory: UINavigationControllerDelegate {

  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    WhisperFactory.performControllerMove(viewController)
  }
}
