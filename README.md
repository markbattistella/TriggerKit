<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# TriggerKit

<small>Perfecting Corners, One Radius at a Time</small>

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FTriggerKit%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FTriggerKit%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`TriggerKit` is a lightweight Swift package designed for building reactive user interface behaviours by responding to state changes through modifiers or standard protocols. It is particularly useful for creating modular, reusable UI components and can be a powerful foundational building block for larger, more feature-rich packages.

## Features

- **Reactive State Handling**: Easily define actions that are triggered when state values change.
- **Extensible Modifier**: Use `StateChangeModifier` to add reactive behaviours to SwiftUI views.
- **Reusable Protocol**: Implement `TriggerActionPerformable` to standardise how triggers and actions are handled across your app.
- **Package Friendly**: Although it can be used directly, it is intended to be integrated into other packages.

## Installation

Add `TriggerKit` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/TriggerKit", from: "1.0.0")
]
```

Alternatively, you can add `TriggerKit` using Xcode by navigating to `File > Add Packages` and entering the package repository URL.

## Recommended Usage

!> Note: While you can use this package directly in your code, it is recommended to wrap it in another package or library to integrate it into a larger system. This design pattern promotes loose coupling, making it easier to use, test, and maintain your application. StateChangeModifier and TriggerActionPerformable are meant to serve as foundational building blocks for more complex state-driven behaviours in other packages, rather than being directly utilised in all instances.

## Usage

### Using `TriggerKit` in Another Swift Package

Instead of directly using `TriggerKit` in your application code, consider wrapping it in a custom package that adds additional functionality. Below is an example of how you might use `TriggerKit` to manage haptic feedback through state changes.

#### Wrapping `TriggerKit` for Haptic Feedback

> See: [HapticsManager](https://github.com/markbattistella/HapticsManager) Swift Package

Let's create a package that implements haptic feedback using `TriggerKit`:

1. Define Custom User Default Keys for Feedback Settings

  ```swift
  public struct HapticFeedbackSettings {
      internal static var isAvailable: Bool { 
        CHHapticEngine.capabilitiesForHardware().supportsHaptics // system level checks
      }
      internal static var isEnabled: Bool { 
        userIsPayingCustomer && !userNeedsHapticFeedback // your custom checks
      }
  }
  ```

1. Define a Custom Performer for Haptic Feedback

  ```swift
  public struct HapticFeedbackPerformer<T: Equatable>: TriggerActionPerformable, FeedbackSettingsConfigurable {
      public typealias Trigger = T

      public enum Feedback {
          case impact(UIImpactFeedbackGenerator.FeedbackStyle)
      }

      public static var isAvailable: Bool { HapticFeedbackSettings.isAvailable }
      public static var isEnabled: Bool { HapticFeedbackSettings.isEnabled }

      public static func perform(_ feedback: Feedback) {
        // your logic here
      }

      public static func canPerform() -> Bool { isAvailable && isEnabled }
  }
  ```

1. Define a SwiftUI View Modifier for Haptic Feedback

  Next, we use `StateChangeModifier` to create a view modifier that provides haptic feedback based on trigger state changes:

  ```swift
  public extension View {
      func hapticFeedback<T: Equatable>(
          _ feedback: HapticFeedbackPerformer<T>.Feedback,
          trigger: T
      ) -> some View {
          self.modifier(
              StateChangeModifier(
                  feedback,
                  trigger: trigger,
                  actionHandler: { feedback in
                      guard HapticFeedbackPerformer<T>.canPerform() else { return }
                      HapticFeedbackPerformer<T>.perform(feedback)
                  }
              )
          )
      }
  }
  ```

### Example Usage in Another Package

```swift
import SwiftUI

struct ContentView: View {
    @State private var isButtonTapped = false

    var body: some View {
        Button(action: {
            isButtonTapped.toggle()
        }) {
            Text("Tap Me")
        }
        .hapticFeedback(
            .impact(.light),
            trigger: isButtonTapped
        )
    }
}
```

In this example, every time the button is tapped, a light haptic impact feedback is provided, but only if haptics are enabled and available.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any features, fixes, or improvements.

## License

`TriggerKit` is available under the MIT license. See the LICENCE file for more information.
