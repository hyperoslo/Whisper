import UIKit

public func show(whisper message: Message, to: UINavigationController, action: WhisperAction = .Show) {
  whisperFactory.craft(message, navigationController: to, action: action)
}

public func hide(whisperFrom from: UINavigationController, after: NSTimeInterval = 0) {
  whisperFactory.silentWhisper(from, after: after)
}

public func show(shout announcement: Announcement, to: UIViewController, completion: (() -> Void)? = nil) {
  shoutView.craft(announcement, to: to, completion: completion)
}

public func show(whistle murmur: Murmur, action: WhistleAction = .Show(1.5)) {
  whistleFactory.whistler(murmur, action: action)
}

public func hide(whistleAfter after: NSTimeInterval = 0) {
  whistleFactory.calm(after: after)
}
