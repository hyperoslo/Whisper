import UIKit
import Whisper

class ModalViewController: UIViewController {
  
  lazy var doneButton: UIBarButtonItem = { [unowned self] in
    let button = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.Done,
      target: self,
      action: "dismissModalViewController")
    
    return button
    }()
  
  lazy var disclosureButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "presentDisclosure:", forControlEvents: .TouchUpInside)
    button.setTitle("Disclosure", forState: .Normal)
    
    button.setTitleColor(UIColor.grayColor(), forState: .Normal)
    button.layer.borderColor = UIColor.grayColor().CGColor
    button.layer.borderWidth = 1.5
    button.layer.cornerRadius = 7.5
    
    return button
    }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.whiteColor()
    
    navigationItem.title = "Secret View"
    
    navigationItem.rightBarButtonItem = doneButton
    
    view.addSubview(disclosureButton)
    
    setUpFrames()
  }
  
  
  // MARK: - Orientation changes
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    
    setUpFrames()
  }
  
  
  // MARK: - Actions
  
  
  // MARK: Disclosure button pressed
  func presentDisclosure(button: UIButton) {
    
    var secret = Secret(title: "Secret revealed!")
    secret.textColor = UIColor.whiteColor()
    secret.backgroundColor = UIColor.brownColor()
    
    Disclosure(secret, to: tabBarController!, completion: {
      print("The disclosure was silent")
    })
  }
  
  
  // MARK: Done button pressed
  func dismissModalViewController() {
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // MARK: - Configuration
  func setUpFrames() {
    
    let totalSize = UIScreen.mainScreen().bounds
    let availableHeight = totalSize.height - navigationController!.navigationBar.frame.size.height - tabBarController!.tabBar.frame.size.height
    
    disclosureButton.frame = CGRect(x: 50, y: availableHeight / 2, width: totalSize.width - 100, height: 50)
  }
}
