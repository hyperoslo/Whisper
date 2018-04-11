import UIKit

public func show(whisper message: Message, to: UINavigationController, action: WhisperAction = .show) {
  whisperFactory.craft(message, navigationController: to, action: action)
}

public func show(shout announcement: Announcement, to: UIViewController, completion: (() -> Void)? = nil, tapAction: (([AnyHashable: Any]?) -> Void)? = nil) {
    shoutView.craft(announcement, to: to, completion: completion, tapAction: tapAction)
}

public func show(whistle murmur: Murmur, action: WhistleAction = .show(1.5)) {
  whistleFactory.whistler(murmur, action: action)
}

public func hide(whisperFrom from: UINavigationController, after: TimeInterval = 0) {
  whisperFactory.silentWhisper(from, after: after)
}

public func hide(whistleAfter after: TimeInterval = 0) {
  whistleFactory.calm(after: after)
}
