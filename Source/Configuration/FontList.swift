import UIKit

public struct FontList {

  public struct Shout {
    public static var title = UIFont.boldSystemFont(ofSize: 15)
    public static var subtitle = UIFont.systemFont(ofSize: 13)
  }

  public struct Whistle {
    public static var title = UIFont.systemFont(ofSize: 12)
  }
  
  public struct Whisper {
    public static var title = UIFont(name: "HelveticaNeue", size: 13)!
  }
}
