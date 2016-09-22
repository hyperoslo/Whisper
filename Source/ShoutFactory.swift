import UIKit

let shoutFactory = ShoutFactory()

public func Shout(_ announcement: Announcement, completion: (() -> ())? = {}) {
    shoutFactory.addShout(announcement, completion: completion)
}


open class ShoutFactory:UIViewController, ShoutViewDelegate{
    
    fileprivate var queue:[ShoutView] = []
    fileprivate var displaying:Bool = false
    
    open lazy var shoutWindow: UIWindow = UIWindow()
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupWindow()
        view.clipsToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    func addShout(_ announcement:Announcement, completion: (() -> ())? = {}){
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
            if let window = UIApplication.shared.windows.filter({ $0 != self.shoutWindow}).first {
                window.makeKeyAndVisible()
                self.shoutWindow.windowLevel = UIWindowLevelNormal - 1
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
            self.displaying = false
        }
    }
    
    // MARK: - Setup
    
    open func setupWindow() {
        shoutWindow.addSubview(self.view)
        shoutWindow.backgroundColor = UIColor.clear
        shoutWindow.clipsToBounds = true
        moveWindowToFront()
    }
    
    func moveWindowToFront() {
        let currentStatusBarStyle = UIApplication.shared.statusBarStyle
        shoutWindow.windowLevel = UIWindowLevelStatusBar
        UIApplication.shared.setStatusBarStyle(currentStatusBarStyle, animated: false)
        shoutWindow.makeKeyAndVisible()
    }
    
    
    
    open func setupFrames() {
        if let shout = queue.first{
            shout.setupFrames()
            shoutWindow.frame = shout.bounds
            view.frame = shoutWindow.bounds
        }
    }


    func orientationDidChange() {
        if shoutWindow.isKeyWindow {
            setupFrames()
            if let shout = queue.first{
                shout.silent()
            }
        }
    }
    
    // MARK: - ShoutViewDelegate
    func shoutViewDidHide(_ shoutView:ShoutView){
        self.displayNext()
    }
}
