//
//  WhisperWindow.swift
//  Pods
//
//  Created by Abdul Moiz on 2017-05-31.
//
//

import Foundation

public class WindowFrameObserver: NSObject {
    static public let shared = WindowFrameObserver()
    
    deinit {
        stopObserving()
    }
    
    public func startObserving() {
        if let window = UIApplication.shared.delegate?.window {
            window?.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        }
    }
    
    public func stopObserving() {
        if let window = UIApplication.shared.delegate?.window {
            window?.removeObserver(self, forKeyPath: "frame")
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.windowFrameChanged), object: nil)
    }
}
