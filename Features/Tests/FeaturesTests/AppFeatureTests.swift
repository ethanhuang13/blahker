import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class AppFeatureTests: XCTestCase {
  func testAppLaunch_userHaventEnableContentBlocker() async throws {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() }
    )

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.checkUserEnabledContentBlocker)
    await store.receive(.userEnableContentBlocker(false))
  }
}
