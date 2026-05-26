//
// Project: TriggerKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Testing

@testable import TriggerKit

@MainActor
@Suite("StateChangeModifier")
struct StateChangeModifierTests {

  @Test("Static actions resolve by default")
  func staticActionResolvesByDefault() {
    let modifier = StateChangeModifier("changed", trigger: false) { _ in }

    #expect(modifier.resolvedAction(previousValue: false, newValue: true) == "changed")
  }

  @Test("Static actions respect conditions")
  func staticActionRespectsCondition() {
    let modifier = StateChangeModifier("increased", trigger: 1, condition: <) { _ in }

    #expect(modifier.resolvedAction(previousValue: 1, newValue: 2) == "increased")
    #expect(modifier.resolvedAction(previousValue: 2, newValue: 1) == nil)
  }

  @Test("Dynamic actions resolve from old and new values")
  func dynamicActionUsesOldAndNewValues() {
    let modifier = StateChangeModifier<Int, String>(
      trigger: 2,
      dynamicAction: { previousValue, newValue in
        previousValue == newValue ? nil : "\(previousValue)->\(newValue)"
      },
      actionHandler: { _ in }
    )

    #expect(modifier.resolvedAction(previousValue: 1, newValue: 2) == "1->2")
    #expect(modifier.resolvedAction(previousValue: 2, newValue: 2) == nil)
  }
}
