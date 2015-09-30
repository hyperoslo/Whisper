import UIKit

public protocol Whisperable {

  func present(notification: Notification)
  func show(notification: Notification)
  func change(notification: Notification)
  func hide()
}

public protocol WhisperMovable {
  func whisperWillSetContentTop(top: CGFloat)
}
