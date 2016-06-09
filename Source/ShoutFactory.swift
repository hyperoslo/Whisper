import UIKit

let shoutFactory = ShoutFactory()

public func Shout(announcement: Announcement, completion: (() -> ())? = {}) {
    shoutFactory.addShout(announcement, completion: completion)
}


public class ShoutFactory:UIViewController, ShoutViewDelegate{
    
    private var queue:[ShoutView] = []
    private var displaying:Bool = false
    
    public lazy var shoutWindow: UIWindow = UIWindow()
    
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
    
    
    func addShout(announcement:Announcement, completion: (() -> ())? = {}){
        let shout = ShoutView(announcement: announcement, completion: completion)
        shout.delegate = self
        self.queue.append(shout)
        if !displaying{
            moveWindowToFront()
            self.displaying = true
            self.displayNext()
        }
    }
    
    func displayNext(){
        if let shout = queue.first{
            shout.craft(shout.announcement!, to: self, completion: shout.completion)
            setupFrames()
            queue.removeFirst()
        }
        else{
            if let window = UIApplication.sharedApplication().windows.filter({ $0 != self.shoutWindow}).first {
                window.makeKeyAndVisible()
                self.shoutWindow.windowLevel = UIWindowLevelNormal - 1
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
            self.displaying = false
        }
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
    
    
    
    public func setupFrames() {
        if let shout = queue.first{
            shout.setupFrames()
            shoutWindow.frame = shout.bounds
            view.frame = shoutWindow.bounds
            print(self.view.bounds)
        }
    }


    func orientationDidChange() {
        if shoutWindow.keyWindow {
            setupFrames()
            if let shout = queue.first{
                shout.silent()
            }
        }
    }
    
    // MARK: - ShoutViewDelegate
    func shoutViewDidHide(shoutView:ShoutView){
        self.displayNext()
    }
}
