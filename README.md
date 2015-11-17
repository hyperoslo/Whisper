# Whisper :dash:

[![Version](https://img.shields.io/cocoapods/v/Whisper.svg?style=flat)](http://cocoadocs.org/docsets/Whisper)
[![License](https://img.shields.io/cocoapods/l/Whisper.svg?style=flat)](http://cocoadocs.org/docsets/Whisper)
[![Platform](https://img.shields.io/cocoapods/p/Whisper.svg?style=flat)](http://cocoadocs.org/docsets/Whisper)

## Description

**Whisper** is a UI component that will make the task of display messages and in-app notifications simple. It has two different views.

#### Whispers

![Whisper](https://github.com/hyperoslo/Whisper/blob/feature/README/Resources/permanent-whisper.png)

Display a short message at the bottom of the navigation bar. It can have images or even a loader.

#### Shouts

![In-App](https://github.com/hyperoslo/Whisper/blob/feature/README/Resources/in-app-notification.png)

Fully customizable, from colors to fonts.

The factory will handle the inset of the scroll view and adjust it to fit the Whisper, if you move from one view controller to another, it will animate the next controller's offset too.

## Usage

The usage of the component is so simple, you just create a message in the case of Whisper, or an announcement in the case of a Shout, it's done like this:

##### For a Whisper:

```swift
let message = Message(title: "Enter your message here.", color: UIColor.redColor())
Whisper(message, to: navigationController, action: .Present)
```

##### For a Shout:

```swift
let announcement = Announcement(title: "Your title", subtitle: "Your subtitle", image: UIImage(named: "avatar"))
Shout(announcement, to: self)
```

Shouts let you add more properties like duration or action. With this, you'll get notified when the user **taps** the view.

## Installation

**Whisper** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Whisper'
```

## Roadmap

In the future the idea is to keep improving and add some features:

- Improve the offset detection and animation.
- Add more UI related components into Whisper.
- More customization points and more sizes for each whisper.
- Actions to Whispers and Shouts.
- We are open to new and awesome ideas, contribute if you like! :)

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**Whisper** is available under the MIT license. See the LICENSE file for more information.
