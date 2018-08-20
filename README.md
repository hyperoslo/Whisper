⚠️ DEPRECATED, NO LONGER MAINTAINED

![Whisper](https://github.com/hyperoslo/Whisper/blob/master/Resources/whisper-cover.png)

![CircleCI](https://circleci.com/gh/hyperoslo/Whisper.png)
[![Version](https://img.shields.io/cocoapods/v/Whisper.svg?style=flat)](http://cocoadocs.org/docsets/Whisper)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Whisper.svg?style=flat)](http://cocoadocs.org/docsets/Whisper)
[![Platform](https://img.shields.io/cocoapods/p/Whisper.svg?style=flat)](http://cocoadocs.org/docsets/Whisper)
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

## Description :leaves:

Break the silence of your UI, whispering, shouting or whistling at it. **Whisper** is a component that will make the task of displaying messages and in-app notifications simple. It has three different views inside.

#### Whispers

![Whisper](https://github.com/hyperoslo/Whisper/blob/master/Resources/permanent-whisper.png)

Display a short message at the bottom of the navigation bar—this can be anything, from a "Great Job!" to an error message. It can have images or even a loader.

#### Shouts

![In-App](https://github.com/hyperoslo/Whisper/blob/master/Resources/in-app-notification.png)

Let users know that something happened inside the app with this beautiful customizable in-app notification.

#### Whistles

![Whistle](https://github.com/hyperoslo/Whisper/blob/master/Resources/whistle-information.png)

This is the smallest of all, a beautiful discretion in your UI.

##### Bonus

All sounds are fully customizable, as are colors and fonts.

Shouts have an optional action that will be called if the user taps on it, and you'll even get a message when the Shout is gone. Finally, if you want to set how long the Shout should be displayed, you have a duration property.

In Whisper, there is no need to think about scroll view insets anymore—this will be handled automatically. As an added bonus, when transitioning from one view controller to another, the next controller's offset will be adjusted as you'd expect. It just works!

## Usage

The usage of the component is so simple, you just create a message in the case of Whisper, an announcement in the case of a Shout, or a Murmur in the case of a Whistle. Because there may be a conflict with `show` from `UIViewController`, you need to explicitly use the `Whisper` namespace to call `show`.

##### For a Whisper:

```swift
let message = Message(title: "Enter your message here.", backgroundColor: .red)

// Show and hide a message after delay
Whisper.show(whisper: message, to: navigationController, action: .show)

// Present a permanent message
Whisper.show(whisper: message, to: navigationController, action: .present)

// Hide a message
Whisper.hide(whisperFrom: navigationController)
```

##### For a Shout:

```swift
let announcement = Announcement(title: "Your title", subtitle: "Your subtitle", image: UIImage(named: "avatar"))
Whisper.show(shout: announcement, to: navigationController, completion: {
  print("The shout was silent.")
})
```

##### For a Whistle:

```swift
let murmur = Murmur(title: "This is a small whistle...")

// Show and hide a message after delay
Whisper.show(whistle: murmur, action: .show(0.5))

// Present a permanent status bar message
Whisper.show(whistle: murmur, action: .present)

// Hide a message
Whisper.hide(whistleAfter: 3)
```

If you want to use **Whisper** with Objective-C, you can find information about it [here](https://github.com/hyperoslo/Whisper/wiki/Using-Whisper-in-Objective-C).

## Installation

**Whisper** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Whisper'
```

**Whisper** is also available through [Carthage](https://github.com/Carthage/Carthage). To install just write into your Cartfile:

```ruby
github "hyperoslo/Whisper"
```

## Roadmap

In the future the idea is to keep improving and add some features:

- Improve the offset detection and animation.
- Add more UI related components into Whisper.
- More customization points and more sizes for each whisper.
- Custom actions inside Whispers and Shouts.
- We are open to new and awesome ideas, contribute if you like! :)

## Author

[Hyper](http://hyper.no) made this with ❤️

## Contribute

We would love for you to contribute to **Whisper**, check the [CONTRIBUTING](https://github.com/hyperoslo/Whisper/blob/master/CONTRIBUTING.md) file for more info.

## License

**Whisper** is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Whisper/blob/master/LICENSE.md) file for more info.
