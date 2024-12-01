//
// Project: TriggerKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A `ViewModifier` that triggers an action when a specified state changes.
///
/// `StateChangeModifier` is used to modify a SwiftUI `View` by performing actions in response
/// to changes in a trigger value. It supports both static and dynamic actions, which can be
/// configured to execute conditionally based on the old and new values of the trigger.
///
/// This modifier is particularly useful for observing state changes and executing
/// appropriate actions as a result, enabling powerful reactive user interface behaviors.
///
/// It can be initialized with a static action, a conditionally-triggered static action, or
/// a dynamically generated action based on changing state.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, visionOS 1.0, *)
public struct StateChangeModifier<T: Equatable, Action>: ViewModifier {

    /// Holds the previous value of the trigger.
    @State private var previousTrigger: T?

    /// Represents a static action to be performed.
    private let staticAction: Action?

    /// Represents the current value of the trigger.
    private let trigger: T

    /// The closure used to handle actions.
    private let actionHandler: (Action) -> Void

    /// An optional closure that determines whether the action should be triggered based on old
    /// and new values.
    private let shouldTrigger: ((T, T) -> Bool)?

    /// An optional closure that provides a dynamic action based on old and new trigger values.
    private let dynamicActionClosure: ((T, T) -> Action?)?
}

// MARK: - Initializers

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, visionOS 1.0, *)
extension StateChangeModifier {

    /// Initializes a `StateChangeModifier` with a static action.
    ///
    /// - Parameters:
    ///   - staticAction: The static action to be performed.
    ///   - trigger: The value used as a trigger for changes.
    ///   - actionHandler: A closure to handle the action.
    public init(
        _ staticAction: Action,
        trigger: T,
        actionHandler: @escaping (Action) -> Void
    ) {
        self.staticAction = staticAction
        self.trigger = trigger
        self.actionHandler = actionHandler
        self.shouldTrigger = nil
        self.dynamicActionClosure = nil
    }

    /// Initializes a `StateChangeModifier` with a static action and a condition for triggering.
    ///
    /// - Parameters:
    ///   - staticAction: The static action to be performed.
    ///   - trigger: The value used as a trigger for changes.
    ///   - condition: A closure that determines if the action should be triggered based on
    ///   previous and current values.
    ///   - actionHandler: A closure to handle the action.
    public init(
        _ staticAction: Action,
        trigger: T,
        condition: @escaping (T, T) -> Bool,
        actionHandler: @escaping (Action) -> Void
    ) {
        self.staticAction = staticAction
        self.trigger = trigger
        self.actionHandler = actionHandler
        self.shouldTrigger = condition
        self.dynamicActionClosure = nil
    }

    /// Initializes a `StateChangeModifier` with a dynamic action.
    ///
    /// - Parameters:
    ///   - trigger: The value used as a trigger for changes.
    ///   - dynamicAction: A closure that returns an optional action based on the previous and
    ///   current trigger values.
    ///   - actionHandler: A closure to handle the action.
    public init(
        trigger: T,
        dynamicAction: @escaping (T, T) -> Action?,
        actionHandler: @escaping (Action) -> Void
    ) {
        self.staticAction = nil
        self.trigger = trigger
        self.actionHandler = actionHandler
        self.shouldTrigger = nil
        self.dynamicActionClosure = dynamicAction
    }
}

// MARK: - Body View

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, visionOS 1.0, *)
extension StateChangeModifier {

    /// Provides the body of the `View` that applies this modifier.
    ///
    /// - Parameter content: The content view that is modified.
    /// - Returns: A modified `View` that handles trigger changes.
    public func body(content: Content) -> some View {
        Group {
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                content
                    .onChange(of: trigger, initial: true) { oldValue, newValue in
                        if previousTrigger == nil {
                            previousTrigger = oldValue
                        }
                        handleTriggerChange(newValue)
                    }
            } else {
                content
                    .onAppear { previousTrigger = trigger }
                    .onChange(of: trigger) { newValue in
                        handleTriggerChange(newValue)
                    }
            }
        }
    }
}

// MARK: - Helper Methods

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, visionOS 1.0, *)
extension StateChangeModifier {

    /// Handles changes to the trigger value.
    ///
    /// - Parameter newValue: The new value of the trigger.
    private func handleTriggerChange(_ newValue: T) {
        guard let previousValue = previousTrigger else { return }
        if let dynamicActionClosure = dynamicActionClosure {
            handleDynamicAction(previousValue, newValue, dynamicActionClosure)
        } else if let staticAction = staticAction {
            handleStaticAction(previousValue, newValue, staticAction)
        }
        previousTrigger = newValue
    }

    /// Handles a dynamic action based on changes to the trigger values.
    ///
    /// - Parameters:
    ///   - previousValue: The previous value of the trigger.
    ///   - newValue: The new value of the trigger.
    ///   - dynamicActionClosure: A closure that returns an optional action based on the previous
    ///   and current values.
    private func handleDynamicAction(
        _ previousValue: T,
        _ newValue: T,
        _ dynamicActionClosure: (T, T) -> Action?
    ) {
        if let dynamicAction = dynamicActionClosure(previousValue, newValue) {
            actionHandler(dynamicAction)
        }
    }

    /// Handles a static action based on changes to the trigger values.
    ///
    /// - Parameters:
    ///   - previousValue: The previous value of the trigger.
    ///   - newValue: The new value of the trigger.
    ///   - staticAction: The static action to be performed.
    private func handleStaticAction(
        _ previousValue: T,
        _ newValue: T,
        _ staticAction: Action
    ) {
        let shouldTriggerAction = (shouldTrigger ?? { _, _ in true })(previousValue, newValue)
        if shouldTriggerAction {
            actionHandler(staticAction)
        }
    }
}
