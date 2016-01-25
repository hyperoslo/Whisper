import UIKit

public enum Action: String {
  case Present = "Whisper.PresentNotification"
  case Show = "Whisper.ShowNotification"
}

@objc public enum Direction: Int {
  case Down = 0
  case Up
}

public struct WhisperNotifications {
  public static let willAppearNotification : String = "WhisperWillAppearNotification"
  public static let willDisappearNotification : String = "WhisperWillDisappearNotification"
}

@objc public protocol WhisperHandler {
  var whisper: WhisperView? { get }
  func whisperYPosition(direction: Direction) -> CGFloat
}

public func Whisper<T:UIViewController where T:WhisperHandler>(message: Message, to: T, action: Action = .Show) {
  whisperFactory.craft(message, controller: to, action: action, direction: .Down)
}

public func Whisper<T:UIViewController where T:WhisperHandler>(message: Message, to: T, action: Action = .Show, direction: Direction) {
  whisperFactory.craft(message, controller: to, action: action, direction: direction)
}

public func Silent<T:UIViewController where T:WhisperHandler>(controller: T, after: NSTimeInterval = 0) {
  whisperFactory.silentWhisper(controller, after: after)
}

let whisperFactory: WhisperFactory = WhisperFactory()

class WhisperFactory: NSObject {
  static let whisperTag = 546;
  struct AnimationTiming {
    static let movement: NSTimeInterval = 0.3
    static let switcher: NSTimeInterval = 0.1
    static let popUp: NSTimeInterval = 1.5
    static let loaderDuration: NSTimeInterval = 0.7
    static let totalDelay: NSTimeInterval = popUp + movement * 2
  }

  var delayTimer = NSTimer()
  var presentTimer = NSTimer()

  func craft<T:UIViewController where T:WhisperHandler>(message: Message, controller: T, action: Action, direction: Direction) {
    presentTimer.invalidate()

    if nil != controller.whisper {
      changeView(message, controller:controller, action: action, direction: direction)
    } else {
      presentView(message, controller:controller, action:action, direction: direction)
    }
  }
  
  func presentView<T:UIViewController where T:WhisperHandler>(message: Message, controller: T, action: Action, direction: Direction) {
    let whisperView = WhisperView(height: controller.whisperYPosition(direction), message: message, direction: direction)
    whisperView.frame.size.height = 0
    
    whisperView.transformViews.forEach {
      $0.frame.origin.y = -10
      $0.alpha = 0
    }
    
    whisperView.frame.origin.y = controller.whisperYPosition(direction)
    whisperView.tag = WhisperFactory.whisperTag;
    controller.view.addSubview(whisperView)
    
    switch action {
    case .Present:
      showView(controller, completion:nil)
    case .Show:
      showView(controller) { _ in
        self.delayTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self,
          selector: "delayFired:", userInfo: nil, repeats: false)
      }
    }
  }

  func silentWhisper<T:UIViewController where T:WhisperHandler>(controller: T, after: NSTimeInterval) {
    delayTimer.invalidate()
    delayTimer = NSTimer.scheduledTimerWithTimeInterval(after, target: self,
      selector: "delayFired:", userInfo: ["controller": controller], repeats: false)
  }

  // MARK: - Presentation

  func showView<T:UIViewController where T:WhisperHandler>(controller: T, completion: ((Bool) -> Void)?) {
    guard let whisperView = controller.whisper else {return}
    
    NSNotificationCenter.defaultCenter().postNotificationName(WhisperNotifications.willAppearNotification, object: nil, userInfo:["duration": AnimationTiming.movement])
    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      whisperView.frame.size.height = whisperView.calculatedHeight()
      if (whisperView.direction == .Up){
        whisperView.frame.origin.y = CGRectGetMinY(whisperView.frame) - whisperView.calculatedHeight()
      }
      for subview in whisperView.transformViews {
        subview.frame.origin.y = 0

        if subview == whisperView.complementImageView {
          subview.frame.origin.y = (WhisperView.Dimensions.height - WhisperView.Dimensions.imageSize) / 2
        }

        subview.alpha = 1
      }
      }, completion: completion)
  }

  func changeView<T:UIViewController where T:WhisperHandler>(message: Message, controller:T, action: Action, direction: Direction) {
    if nil == controller.whisper {return}
    
    presentTimer.invalidate()
    delayTimer.invalidate()
    hideView(controller.whisper!)

    let title = message.title
    let textColor = message.textColor
    let backgroundColor = message.backgroundColor
    let action = action.rawValue
    let dir = direction.rawValue

    var array = ["title": title, "textColor" : textColor, "backgroundColor": backgroundColor, "controller": controller, "action": action, "direction": dir]
    if let images = message.images { array["images"] = images }

    presentTimer = NSTimer.scheduledTimerWithTimeInterval(AnimationTiming.movement * 1.1, target: self,
      selector: "presentFired:", userInfo: array, repeats: false)
  }

  func hideView(whisperView: WhisperView) {
    NSNotificationCenter.defaultCenter().postNotificationName(WhisperNotifications.willDisappearNotification, object: nil, userInfo:["duration": AnimationTiming.movement])
    UIView.animateWithDuration(AnimationTiming.movement, animations: {
      for subview in whisperView.transformViews {
        subview.frame.origin.y = -10
        subview.alpha = 0
      }
      whisperView.frame.size.height = 0
      if (whisperView.direction == .Up){
        whisperView.frame.origin.y = CGRectGetMinY(whisperView.frame) + whisperView.calculatedHeight()
        whisperView.isClosing = true
      }
    }, completion: { _ in
        whisperView.removeFromSuperview()
    })
  }

  // MARK: - Timer methods

  func delayFired(timer: NSTimer) {
    guard let userInfo = timer.userInfo,
      controller = userInfo["controller"] as? WhisperHandler,
      whisperView = controller.whisper else {return}
    hideView(whisperView)
  }

  func presentFired(timer: NSTimer) {
    guard let userInfo = timer.userInfo,
      title = userInfo["title"] as? String,
      textColor = userInfo["textColor"] as? UIColor,
      backgroundColor = userInfo["backgroundColor"] as? UIColor,
      actionString = userInfo["action"] as? String,
      directionInt = userInfo["direction"] as? Int,
      controller = userInfo["controller"] as? UIViewController else { return }

    var images: [UIImage]? = nil
    if let imageArray = userInfo["images"] as? [UIImage]? { images = imageArray }

    let action = Action(rawValue: actionString)
    let direction = Direction(rawValue: directionInt)
    let message = Message(title: title, textColor: textColor, backgroundColor: backgroundColor, images: images)
    
    presentView(message, controller: controller, action: action!, direction: direction!)
  }
}

extension UIViewController : WhisperHandler {
  public var whisper: WhisperView? {
    get {
      return view.viewWithTag(WhisperFactory.whisperTag) as? WhisperView
    }
  }
  public func whisperYPosition(direction: Direction) -> CGFloat {
    if direction == .Down {
      return max(CGRectGetMinY(view.bounds), self.topLayoutGuide.length)
    }else{
      return min(CGRectGetMaxY(view.bounds), self.bottomLayoutGuide.length)
    }
  }
  
  public override class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }
    
    // make sure this isn't a subclass
    if self !== UIViewController.self {
      return
    }
    
    dispatch_once(&Static.token) {
      let originalSelector = Selector("viewWillLayoutSubviews")
      let swizzledSelector = Selector("whisper_viewWillLayoutSubviews")
      
      let originalMethod = class_getInstanceMethod(self, originalSelector)
      let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
      
      let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
      
      if didAddMethod {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }
  
  // MARK: - Method Swizzling
  
  public func whisper_viewWillLayoutSubviews() {
    self.whisper_viewWillLayoutSubviews() //Call original method
    guard let whisperView = self.whisper else {return}
    if (whisperView.direction == .Up && !whisperView.isClosing){
      whisperView.frame.origin.y = self.whisperYPosition(whisperView.direction) - whisperView.calculatedHeight()
    }else{
      whisperView.frame.origin.y = self.whisperYPosition(whisperView.direction)
    }
    whisperView.frame.size.width = CGRectGetWidth(view.bounds)
  }
}