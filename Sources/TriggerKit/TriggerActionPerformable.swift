//
// Project: TriggerKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A protocol that defines a type capable of performing actions in response to a trigger.
///
/// Types conforming to `TriggerActionPerformable` are designed to handle triggers and perform
/// actions based on their availability and state. This can be particularly useful for managing
/// event-driven responses in a consistent way across different parts of an application.
///
/// Conformers are required to specify associated types for `Trigger` and `Action`, as well as
/// implement functionality to check availability and enablement, and to perform an action.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, visionOS 1.0, *)
public protocol TriggerActionPerformable {

    /// The type representing a trigger for the action.
    associatedtype Trigger: Equatable

    /// The type representing an action that can be performed.
    associatedtype Action

    /// A Boolean value indicating if the action is available for use.
    static var isAvailable: Bool { get }

    /// A Boolean value indicating if the action is enabled.
    static var isEnabled: Bool { get }

    /// Performs the specified action.
    ///
    /// - Parameter action: The action to be performed.
    static func perform(_ action: Action)
}
