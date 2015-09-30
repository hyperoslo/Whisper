import UIKit

public class Notification {

  public enum Kind: String {
    case Default = "Default"
    case Loader = "Loading"
  }

  public enum Action: String {
    case Present = "Whisper.PresentNotification"
    case Show = "Whisper.ShowNotification"
    case Hide = "Whisper.HideNotification"
  }

  public var title: String
  public var color: UIColor
  public var image: UIImage?
  public var kind = Kind.Default

  public init(title: String, color: UIColor = UIColor.lightGrayColor(), image: UIImage? = nil, kind: Kind = .Default) {
    self.title = title
    self.color = color
    self.image = image
    self.kind = kind
  }
}
