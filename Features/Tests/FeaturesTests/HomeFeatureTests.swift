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
