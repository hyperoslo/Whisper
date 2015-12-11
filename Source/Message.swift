import UIKit

public struct Message {

  public var title: String
  public var color: UIColor
  public var images: [UIImage]?

  public init(title: String, color: UIColor = UIColor.lightGrayColor(), images: [UIImage]? = nil) {
    self.title = title
    self.color = color
    self.images = images
  }
}

public struct Announcement {

  public var title: String
  public var subtitle: String?
  public var image: UIImage?
  public var duration: NSTimeInterval
  public var action: (() -> Void)?

  public init(title: String, subtitle: String? = nil, image: UIImage? = nil, duration: NSTimeInterval = 2, action: (() -> Void)? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
    self.duration = duration
    self.action = action
  }
}

public struct Murmur {

  public var title: String
  public var duration: NSTimeInterval
  public var backgroundColor: UIColor
  public var titleColor: UIColor
  public var font: UIFont

  public init(title: String, duration: NSTimeInterval = 1.5, backgroundColor: UIColor = ColorList.Whistle.background, titleColor: UIColor = ColorList.Whistle.title, font: UIFont = FontList.Whistle.title) {
    self.title = title
    self.duration = duration
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.font = font
  }
}
