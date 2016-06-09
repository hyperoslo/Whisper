import UIKit

let shoutFactory = ShoutFactory()

public func Shout(announcement: Announcement, completion: (() -> ())? = {}) {
    shoutFactory.shout(announcement, completion: completion)
}


public class ShoutFactory:UIViewController{
    
    public lazy var shoutWindow: UIWindow = UIWindow()
    let shout = ShoutView()
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupWindow()
        view.clipsToBounds = true

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Setup
    
    public func setupWindow() {
        shoutWindow.addSubview(self.view)
        shoutWindow.backgroundColor = UIColor.clearColor()
        shoutWindow.clipsToBounds = true
        moveWindowToFront()
    }
    
    func moveWindowToFront() {
        let currentStatusBarStyle = UIApplication.sharedApplication().statusBarStyle
        shoutWindow.windowLevel = UIWindowLevelStatusBar
        UIApplication.sharedApplication().setStatusBarStyle(currentStatusBarStyle, animated: false)
        shoutWindow.makeKeyAndVisible()
    }
    
    func shout(announcement:Announcement, completion: (() -> ())? = {}){
        shout.craft(announcement, to: self){
            completion?()
            if let window = UIApplication.sharedApplication().windows.filter({ $0 != self.shoutWindow}).first {
                window.makeKeyAndVisible()
                self.shoutWindow.windowLevel = UIWindowLevelNormal - 1
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
        }
        moveWindowToFront()
        setupFrames()
    }
    
    public func setupFrames() {
        shout.setupFrames()
        shoutWindow.frame = shout.bounds
        view.frame = shoutWindow.bounds
    }


    func orientationDidChange() {
        if shoutWindow.keyWindow {
            setupFrames()
            shout.silent()
        }
    }
    

}
