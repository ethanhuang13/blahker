import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class BlockerListFeatureTests: XCTestCase {
  func testDownloadBlockerList() async throws {
    let store = TestStore(
      initialState: BlockerListFeature.State(),
      reducer: { BlockerListFeature() }
    )

    await store.send(\.task)
    await store.receive(\.receiveRuleItems, [])
  }
}
