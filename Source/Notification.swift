import UIKit

public class Notification {

  public enum Kind: String {
    case Default = "Default"
    case Searching = "Searching"
  }

  public var title: String
  public var color: UIColor
  public var image: UIImage?
  public var kind = Kind.Default

  public init(title: String, color: UIColor, image: UIImage? = nil, kind: Kind = .Default) {
    self.title = title
    self.color = color
    self.image = image
    self.kind = kind
  }
}
