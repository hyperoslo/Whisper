import UIKit

public enum Action: String {
  case Present = "Whisper.PresentNotification"
  case Show = "Whisper.ShowNotification"
}

let whisperFactory: WhisperFactory = WhisperFactory()

public func Whisper(message: Message, to: UINavigationController, action: Action = .Show) {
  whisperFactory.craft(message, navigationController: to, action: action)
}

public func Silent(controller: UINavigationController, after: NSTimeInterval = 0) {
  whisperFactory.silentWhisper(controller, after: after)
}

class WhisperFactory: NSObject {

  struct AnimationTiming {
    static let movement: NSTimeInterval = 0.3
    static let switcher: NSTimeInterval = 0.1
    static let popUp: NSTimeInterval = 1.5
    static let loaderDuration: NSTimeInterval = 0.7
    static let totalDelay: NSTimeInterval = popUp + movement * 2
  }

  var navigationController = UINavigationController()
  var edgeInsetHeight: CGFloat = 0
  var whisperView: WhisperView!
  var delayTimer = NSTimer()
  var presentTimer = NSTimer()
  var navigationStackCount = 0

  // MARK: - Initializers

  override init() {
    super.init()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  func craft(message: Message, navigationController: UINavigationController, action: Action) {
    self.navigationController = navigationController
    self.navigationController.delegate = self
    presentTimer.invalidate()

    var containsWhisper = false
    for subview in navigationController.navigationBar.subviews {
      if let whisper = subview as? WhisperView {
        whisperView = whisper
        containsWhisper = true
        break
      }
    }

    if !containsWhisper {
      whisperView = WhisperView(height: navigationController.navigationBar.frame.height, message: message)
      whisperView.frame.size.height = 0
      var maximumY = navigationController.navigationBar.frame.height

      whisperView.transformViews.forEach {
        $0.frame.origin.y = -10
        $0.alpha = 0
      }

      for subview in navigationController.navigationBar.subviews {
        if subview.frame.maxY > maximumY && subview.frame.height > 0 { maximumY = subview.frame.maxY }
      }

      whisperView.frame.origin.y = maximumY
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

  func silentWhisper(controller: UINavigationController, after: NSTimeInterval) {
    navigationController = controller

    var whisperSubview: WhisperView? = nil
    for subview in navigationController.navigationBar.subviews {
      if let whisper = subview as? WhisperView {
        whisperSubview = whisper
        break
      }
    }

    if whisperSubview == nil {
        return
    }

    whisperView = whisperSubview
    delayTimer.invalidate()
    delayTimer = NSTimer.scheduledTimerWithTimeInterval(after, target: self,
      selector: "delayFired:", userInfo: nil, repeats: false)
  }

  // MARK: - Presentation

  func presentView() {
    moveControllerViews(true)

    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      self.whisperView.frame.size.height = WhisperView.Dimensions.height
      for subview in self.whisperView.transformViews {
        subview.frame.origin.y = 0

        if subview == self.whisperView.complementImageView {
          subview.frame.origin.y = (WhisperView.Dimensions.height - WhisperView.Dimensions.imageSize) / 2
        }

        subview.alpha = 1
      }
    })
  }

  func showView() {
    moveControllerViews(true)

    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      self.whisperView.frame.size.height = WhisperView.Dimensions.height
      for subview in self.whisperView.transformViews {
        subview.frame.origin.y = 0

        if subview == self.whisperView.complementImageView {
          subview.frame.origin.y = (WhisperView.Dimensions.height - WhisperView.Dimensions.imageSize) / 2
        }

        subview.alpha = 1
      }
      }, completion: { _ in
        self.delayTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self,
          selector: "delayFired:", userInfo: nil, repeats: false)
    })
  }

  func changeView(message: Message, action: Action) {
    presentTimer.invalidate()
    delayTimer.invalidate()
    hideView()

    let title = message.title
    let textColor = message.textColor
    let backgroundColor = message.backgroundColor
    let action = action.rawValue

    var array = ["title": title, "textColor" : textColor, "backgroundColor": backgroundColor, "action": action]
    if let images = message.images { array["images"] = images }

    presentTimer = NSTimer.scheduledTimerWithTimeInterval(AnimationTiming.movement * 1.1, target: self,
      selector: "presentFired:", userInfo: array, repeats: false)
  }

  func hideView() {
    moveControllerViews(false)

    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      self.whisperView.frame.size.height = 0
      for subview in self.whisperView.transformViews {
        subview.frame.origin.y = -10
        subview.alpha = 0
      }
      }, completion: { _ in
        self.whisperView.removeFromSuperview()
    })
  }

  // MARK: - Timer methods

  func delayFired(timer: NSTimer) {
    hideView()
  }

  func presentFired(timer: NSTimer) {
    guard let userInfo = timer.userInfo,
      title = userInfo["title"] as? String,
      textColor = userInfo["textColor"] as? UIColor,
      backgroundColor = userInfo["backgroundColor"] as? UIColor,
      actionString = userInfo["action"] as? String else { return }

    var images: [UIImage]? = nil

    if let imageArray = userInfo["images"] as? [UIImage]? { images = imageArray }

    let action = Action(rawValue: actionString)
    let message = Message(title: title, textColor: textColor, backgroundColor: backgroundColor, images: images)

    whisperView = WhisperView(height: navigationController.navigationBar.frame.height, message: message)
    navigationController.navigationBar.addSubview(whisperView)
    whisperView.frame.size.height = 0

    var maximumY = navigationController.navigationBar.frame.height

    for subview in navigationController.navigationBar.subviews {
      if subview.frame.maxY > maximumY && subview.frame.height > 0 { maximumY = subview.frame.maxY }
    }

    whisperView.frame.origin.y = maximumY

    action == .Present ? presentView() : showView()
  }

  // MARK: - Animations

  func moveControllerViews(down: Bool) {
    guard let visibleController = navigationController.visibleViewController
      where Config.modifyInset
      else { return }

    let stackCount = navigationController.viewControllers.count

    if down {
      navigationStackCount = stackCount
    } else if navigationStackCount != stackCount {
      return
    }

    if !(edgeInsetHeight == WhisperView.Dimensions.height && down) {
      edgeInsetHeight = down ? WhisperView.Dimensions.height : -WhisperView.Dimensions.height

      UIView.animateWithDuration(AnimationTiming.movement, animations: {
        self.performControllerMove(visibleController)
      })
    }
  }

  func performControllerMove(viewController: UIViewController) {
    guard Config.modifyInset else { return }

    if let tableView = viewController.view as? UITableView
      where viewController is UITableViewController {
        tableView.contentInset = UIEdgeInsetsMake(tableView.contentInset.top + edgeInsetHeight, 0, 0, 0)
    } else if let collectionView = viewController.view as? UICollectionView
      where viewController is UICollectionViewController {
        collectionView.contentInset = UIEdgeInsetsMake(collectionView.contentInset.top + edgeInsetHeight, 0, 0, 0)
    } else {
      for view in viewController.view.subviews {
        if let scrollView = view as? UIScrollView {
          scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top + edgeInsetHeight, 0, 0, 0)
        }
      }
    }
  }

  // MARK: - Handling screen orientation

  func orientationDidChange() {
    for subview in navigationController.navigationBar.subviews {
      guard let whisper = subview as? WhisperView else { continue }

      var maximumY = navigationController.navigationBar.frame.height
      for subview in navigationController.navigationBar.subviews where subview != whisper {
        if subview.frame.maxY > maximumY && subview.frame.height > 0 { maximumY = subview.frame.maxY }
      }

      whisper.frame = CGRect(
        x: whisper.frame.origin.x,
        y: maximumY,
        width: UIScreen.mainScreen().bounds.width,
        height: whisper.frame.size.height)
      whisper.setupFrames()
    }
  }
}

// MARK: UINavigationControllerDelegate

extension WhisperFactory: UINavigationControllerDelegate {

  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    var maximumY = navigationController.navigationBar.frame.maxY - UIApplication.sharedApplication().statusBarFrame.height

    for subview in navigationController.navigationBar.subviews {
      if subview is WhisperView { navigationController.navigationBar.bringSubviewToFront(subview) }

      if subview.frame.maxY > maximumY && !(subview is WhisperView) {
        maximumY = subview.frame.maxY
      }
    }

    whisperView.frame.origin.y = maximumY
  }

  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {

    for subview in navigationController.navigationBar.subviews where subview is WhisperView {
      moveControllerViews(true)

      if let index = navigationController.viewControllers.indexOf(viewController) where index > 0 {
        edgeInsetHeight = -WhisperView.Dimensions.height
        performControllerMove(navigationController.viewControllers[Int(index) - 1])
        break
      }
    }
  }
}
