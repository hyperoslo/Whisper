import UIKit

let disclosure = DisclosureView()

public func Disclosure(secret: Secret, to: UIViewController, completion: (() -> Void)? = {}) {
  disclosure.craft(secret, toViewController: to, completion: completion)
}


public class DisclosureView: UIView {

  public struct Dimensions {
    public static let disclosureHeight: CGFloat = 50
    public static let textHorizontalOffset: CGFloat = 10
    public static let textVerticalOffset: CGFloat = 8
    
    public static var deviceWidth: CGFloat {
      return UIScreen.mainScreen().bounds.width
    }
    
    public static var deviceHeight: CGFloat {
      return UIScreen.mainScreen().bounds.height
    }
  }
  
  public private(set) lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorList.Disclosure.background
    view.alpha = 0.98
    view.clipsToBounds = true
    
    return view
  }()
  
  public private(set) lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = FontList.Disclosure.title
    label.textColor = ColorList.Disclosure.title
    label.textAlignment = .Center
    label.numberOfLines = 1
    
    return label
  }()
  
  public private(set) var secret: Secret?
  public private(set) var displayTimer =  NSTimer()
  public private(set) var shouldSilent = false
  public private(set) var hasTabBar = false
  public private(set) var tabBarHeight: CGFloat = 0
  public private(set) var completion: (() -> ())?
  
  // MARK: - Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(backgroundView)
    backgroundView.addSubview(titleLabel)
    
    clipsToBounds = false
    userInteractionEnabled = false
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: -1.5)
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 0.5

    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  
  // MARK: - Configuration
  
  public func craft(secret: Secret, toViewController viewController: UIViewController, completion: (() -> ())?) {
    
    shouldSilent = false
    
    if viewController is UITabBarController {
      let tabBarController = viewController as! UITabBarController
      hasTabBar = !tabBarController.tabBar.hidden
      tabBarHeight = hasTabBar ? tabBarController.tabBar.frame.size.height : 0
    } else {
      tabBarHeight = 0
    }
    
    
    configureViewFor(secret)
    configureDisplayTimerFor(secret)
    revealTo(viewController)
    
    self.completion = completion
  }
  
  
  public func configureViewFor(secret: Secret) {
    
    self.secret = secret
    titleLabel.text = secret.title
    titleLabel.textColor = secret.textColor
    backgroundView.backgroundColor = secret.backgroundColor
    titleLabel.sizeToFit()
    
    setUpFrames()
  }
  
  
  public func configureDisplayTimerFor(secret: Secret) {
    displayTimer.invalidate()
    displayTimer = NSTimer.scheduledTimerWithTimeInterval(
      secret.duration,
      target: self,
      selector: "displayTimerDidFire",
      userInfo: nil,
      repeats: false)
  }
  
  
  public func revealTo(viewController: UIViewController) {
    
    viewController.view.addSubview(self)
    
    frame = CGRect(x: 0, y: Dimensions.deviceHeight - tabBarHeight, width: Dimensions.deviceWidth, height: Dimensions.disclosureHeight)
    
    backgroundView.frame = CGRect(x: 0, y: 0, width: Dimensions.deviceWidth, height: 0)
    
    UIView.animateWithDuration(0.35, animations: {
      self.frame.origin.y = Dimensions.deviceHeight - self.tabBarHeight - Dimensions.disclosureHeight
      self.backgroundView.frame.size.height = Dimensions.disclosureHeight
    })
  }
  
  
  // MARK: - Setup
  
  public func setUpFrames() {
    let yPos = shouldSilent ? Dimensions.deviceHeight - tabBarHeight : Dimensions.deviceHeight - tabBarHeight - Dimensions.disclosureHeight
    
    frame = CGRect(x: 0, y: yPos, width: Dimensions.deviceWidth, height: Dimensions.disclosureHeight)
    
    backgroundView.frame.size = CGSize(width: Dimensions.deviceWidth, height: Dimensions.disclosureHeight)
    
    titleLabel.frame.origin = CGPoint(x: Dimensions.textHorizontalOffset, y: Dimensions.textVerticalOffset)
    titleLabel.frame.size.width = Dimensions.deviceWidth - 2 * Dimensions.textHorizontalOffset
    
    titleLabel.frame.size.height = Dimensions.disclosureHeight - 2 * Dimensions.textVerticalOffset
  }
  
  
  // MARK: - Actions
  
  public func displayTimerDidFire() {
    shouldSilent = true
    silent()
  }
  
  public func silent() {
    UIView.animateWithDuration(0.35, animations: {
      self.frame.origin.y = Dimensions.deviceHeight - self.tabBarHeight
      self.backgroundView.frame.size.height = 0
      }, completion: { finished in
        self.completion?()
        self.displayTimer.invalidate()
        self.removeFromSuperview()
    } )
  }
  
  
  // MARK: Handling screen orientation
  
  func orientationDidChange() {
    setUpFrames()
  }
}
