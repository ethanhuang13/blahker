import ComposableArchitecture
@testable import Features
import Models
import XCTest

@MainActor
final class BlockerListFeatureTests: XCTestCase {
  func testTask_downloadBlockerList() async throws {
    let ruleItem = RuleItem(domain: "example.com", selectors: [".ad-container"])

    let store = TestStore(
      initialState: BlockerListFeature.State(),
      reducer: { BlockerListFeature() }
    ) {
      $0.contentBlockerService.fetchBlockerList = {
        [ruleItem]
      }
    }

    await store.send(\.task)
    await store.receive(\.receiveRuleItems, [ruleItem]) {
      $0.ruleItems = [ruleItem]
    }
  }

  func testReload_downloadBlockerList() async throws {
    let ruleItem = RuleItem(domain: "example.com", selectors: [".ad-container"])

    let store = TestStore(
      initialState: BlockerListFeature.State(),
      reducer: { BlockerListFeature() }
    ) {
      $0.contentBlockerService.fetchBlockerList = {
        [ruleItem]
      }
    }

    await store.send(\.reload)
    await store.receive(\.receiveRuleItems, [ruleItem]) {
      $0.ruleItems = [ruleItem]
    }
  }
}
