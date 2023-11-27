import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
  func testAppLaunch_userHaventEnableContentBlocker() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
    }

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(false))
  }

  func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
    }

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(true)) {
      $0.isEnabledContentBlocker = true
    }
  }

  func testAppLaunch_userHaventEnableContentBlocker_laterEnabled() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
    }

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(false))

    store.dependencies.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(true)) {
      $0.isEnabledContentBlocker = true
    }
  }
}
