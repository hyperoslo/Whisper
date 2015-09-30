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