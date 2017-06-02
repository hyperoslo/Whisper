import UIKit

public struct Message {

  public var title: String
  public var textColor: UIColor
  public var backgroundColor: UIColor
  public var images: [UIImage]?

  public init(title: String, textColor: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.lightGray, images: [UIImage]? = nil) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.images = images
  }
}

public struct Announcement {

  public var title: String
  public var subtitle: String?
  public var image: UIImage?
  public var duration: TimeInterval
  public var action: (() -> Void)?
  // Closure which is called when notification is dismissed manually
  // not by automatic timer
  public var dismissed: (() -> Void)?

  public init(title: String, subtitle: String? = nil, image: UIImage? = nil, duration: TimeInterval = 2, action: (() -> Void)? = nil, dismissed: (() -> Void)? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
    self.duration = duration
    self.action = action
    self.dismissed = dismissed
  }
}

public struct Murmur {

  public var title: String
  public var backgroundColor: UIColor
  public var titleColor: UIColor
  public var font: UIFont
  public var action: (() -> Void)?

  public init(title: String, backgroundColor: UIColor = ColorList.Whistle.background, titleColor: UIColor = ColorList.Whistle.title, font: UIFont = FontList.Whistle.title, action: (() -> Void)? = nil) {
    self.title = title
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.font = font
    self.action = action
  }
}
