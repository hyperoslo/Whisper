public struct Config {
  public static var modifyInset: Bool = true
}

// Helper to check for Device Type
public enum Model: String {
    case none = "without notch"
    case simulator = "simulator"
    case iPhoneX = "iPhoneX"
}

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.none
    }
    
    struct AssociatedDeviceModel {
        static var modelState: [ String : Model ] = [:]
    }
    
    open var modelMap: [ String : Model ] {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedDeviceModel.modelState) as? [ String: Model] else {
                return ["None": Model.none]
            }
            return value
            
        } set(newValue) {
            objc_setAssociatedObject(self, &AssociatedDeviceModel.modelState, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

