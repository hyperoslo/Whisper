import UIKit

public enum WhisperShowing {
    public static func show(whisper message: Message, to: UINavigationController, action: WhisperAction = .Present) {
        whisperFactory.craft(message, navigationController: to, action: action)
    }

    public static func hide(whisperFrom from: UINavigationController, after: NSTimeInterval = 0) {
        whisperFactory.silentWhisper(from, after: after)
    }

    public static func show(shout announcement: Announcement, to: UIViewController, completion: (() -> Void)? = nil) {
        shoutView.craft(announcement, to: to, completion: completion)
    }

    public static func show(whistle murmur: Murmur, action: WhistleAction = .Present) {
        whistleFactory.whistler(murmur, action: action)
    }

    public static func hide(whistleAfter after: NSTimeInterval = 0) {
        whistleFactory.calm(after: after)
    }
}

