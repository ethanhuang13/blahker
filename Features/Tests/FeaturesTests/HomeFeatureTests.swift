import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
  func testAppBecomeActive_userHaventEnableContentBlocker() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(appLaunchCheck: false),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
    }

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(false)) {
      $0.alert = .pleaseEnableContentBlocker
    }
  }

  func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(appLaunchCheck: true, isEnabledContentBlocker: false),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in
        do {
          try await Task.sleep(for: .seconds(1))
        } catch {
          // cancellation error
          print(error.localizedDescription)
        }
        return true
      }
    }

    await store.send(.appDidFinishLaunching)
    await store.send(.scenePhaseBecomeActive) // Cancel appDidFinishLaunching's effect
    await store.receive(.userEnableContentBlocker(true)) {
      $0.isEnabledContentBlocker = true
      $0.appLaunchCheck = false
    }
  }

  func testAppBecomeActive_userAlreadyEnableContentBlocker() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(appLaunchCheck: false, isEnabledContentBlocker: true),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
    }

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(true))
  }

  func testAppBecomeActive_userHaventEnableContentBlocker_laterEnabled() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(appLaunchCheck: false),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
    }

    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(false)) {
      $0.alert = .pleaseEnableContentBlocker
    }

    store.dependencies.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
    await store.send(.scenePhaseBecomeActive)
    await store.receive(.userEnableContentBlocker(true)) {
      $0.isEnabledContentBlocker = true
      $0.alert = .updateSuccess
    }
  }

  func testTapRefreshButton_userHaventEnableContentBlocker_laterEnabled() async throws {
    let store = TestStore(
      initialState: HomeFeature.State(appLaunchCheck: false),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
    }

    await store.send(.tapRefreshButton)
    await store.receive(.userEnableContentBlocker(false)) {
      $0.alert = .pleaseEnableContentBlocker
    }

    await store.send(.alert(.presented(.okToReloadContentBlocker))) {
      $0.alert = nil
    }
    await store.receive(.userEnableContentBlocker(false)) {
      $0.alert = .pleaseEnableContentBlocker
    }

    // User enable content blocker in system Settings
    store.dependencies.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
    await store.send(.alert(.presented(.okToReloadContentBlocker))) {
      $0.alert = nil
    }
    await store.receive(.userEnableContentBlocker(true)) {
      $0.isEnabledContentBlocker = true
      $0.alert = .updateSuccess
    }
  }

  func testAlert_rate5Star_openAppStoreURL() async throws {
    let openURLExp = XCTestExpectation(description: "openURL")

    let store = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.openURL = .init(handler: { url in
        XCTAssertEqual(url, URL(string: "https://apps.apple.com/tw/app/blahker-巴拉剋/id1182699267")!)
        openURLExp.fulfill()
        return true
      })
    }

    await store.send(.tapDontTapMeButton) {
      $0.alert = AlertState(
        title: TextState("支持開發者"),
        message: TextState("Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～"),
        buttons: [
          ButtonState(
            action: .smallDonation,
            label: {
              TextState("打賞小小費")
            }
          ),
          ButtonState(
            action: .mediumDonation,
            label: {
              TextState("打賞小費")
            }
          ),
          ButtonState(
            action: .largeDonation,
            label: {
              TextState("破費")
            }
          ),
          ButtonState(
            action: .rate5Star,
            label: {
              TextState("我不出錢，給個五星評分總行了吧")
            }
          ),
          ButtonState(
            role: .cancel,
            label: {
              TextState("算了吧，不值得")
            }
          )
        ]
      )
    }

    await store.send(.alert(.presented(.rate5Star))) {
      $0.alert = nil
    }

    await fulfillment(of: [openURLExp], timeout: 1)
  }
}
