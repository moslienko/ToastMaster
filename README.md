<p align="center">
   <img width="200" src="https://raw.githubusercontent.com/SvenTiigi/SwiftKit/gh-pages/readMeAssets/SwiftKitLogo.png" alt="ToastMaster Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" alt="Swift 5.2">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

# ToastMaster

<p align="center">
UIKit library for creating customizable Telegram-style toasts
</p>

<p align="center">
   <img src="https://i.imgur.com/kGPuzOv.png" alt="Screenshot">
</p>

## Example

The example application is the best way to see `ToastMaster` in action. Simply open the `ToastMasterExample.xcodeproj` and run the `ToastMasterExample` scheme.

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moslienko/ToastMaster.git", from: "1.0.0")
]
```

Alternatively navigate to your Xcode project, select `Swift Packages` and click the `+` icon to search for `ToastMaster`.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate ToastMaster into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

### Basic

The basic toast calling looks like this:

```swift
ToastView.shared.show(
    header: "Toast header",
    message: "Toast message",
    icon: UIImage(systemName: "info.circle.fill"),
    actionButtonTitle: "More",
    controller: self,
    buttonTapped: {},
    linkTapped: { link in }
)
```

### Advanced

More advanced configuration is possible by modifying the `ToastConfig` model:

 ```swift
ToastView.shared.config = ToastConfig()
```

 ```swift
struct ToastConfig {
    var layout: ToastLayout
    var containerConfig: ContainerConfig
    var displayConfig: DisplayConfig
    var iconConfig: IconConfig
    var textConfig: TextContentStyleConfig
    var buttonConfig: TextElementConfig
}
```

### Links

For displaying links in a header or message, you need to pass a string with an html tag to the corresponding argument.

 ```swift
ToastView.shared.show(
	header: "Header with <a href=\"http://linkOne\">link</a>",
	...
)
```


## License

```
ToastMaster
Copyright (c) 2024 Pavel Moslienko 8676976+moslienko@users.noreply.github.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
