//
//  HomeFeature.swift
//
//
//  Created by Ethan Huang on 2023/12/7.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
  struct State: Equatable {
    var appLaunchCheck = true
    var isEnabledContentBlocker = false
    @PresentationState var alert: AlertState<Action.Alert>?
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case appDidFinishLaunching
    case scenePhaseBecomeActive
    case userEnableContentBlocker(Bool)
    case manuallyCheckUserEnableContentBlocker(Bool)
    case tapDontTapMeButton
    case tapRefreshButton
    case tapAboutButton

    enum Alert {
      case okToReloadContentBlocker
      case smallDonation
      case mediumDonation
      case largeDonation
      case rate5Star
    }
  }

  @Dependency(\.contentBlockerService) var contentBlockerService
  @Dependency(\.openURL) var openURL

  var body: some ReducerOf<Self> {
    Reduce(core)
      .ifLet(\.$alert, action: \.alert)
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {
    func checkUserEnabledContentBlocker(manually: Bool) -> Effect<Action> {
      .run { send in
        let extensionID = "com.elaborapp.Blahker.ContentBlocker"
        let isEnabled = await contentBlockerService.checkUserEnabledContentBlocker(extensionID)
        await send(manually
          ? .manuallyCheckUserEnableContentBlocker(isEnabled)
          : .userEnableContentBlocker(isEnabled))
      }
      .cancellable(id: CancelID.checkUserEnabledContentBlocker, cancelInFlight: true)
    }

    enum CancelID {
      case checkUserEnabledContentBlocker
    }

    switch action {
    case let .alert(.presented(alert)):
      switch alert {
      case .okToReloadContentBlocker:
        return checkUserEnabledContentBlocker(manually: true)
      case .smallDonation:
        return .none
      case .mediumDonation:
        return .none
      case .largeDonation:
        return .none
      case .rate5Star:
        return .run { send in
          let url = URL(string: "https://apps.apple.com/tw/app/blahker-巴拉剋/id1182699267")!
          await openURL(url)
        }
      }

    case .alert(.dismiss):
      return .none

    case .appDidFinishLaunching:
      return checkUserEnabledContentBlocker(manually: false)

    case .scenePhaseBecomeActive:
      return checkUserEnabledContentBlocker(manually: false)

    case let .userEnableContentBlocker(isEnabled):
      switch (isEnabled, state.appLaunchCheck, state.isEnabledContentBlocker) {
      case (false, _, _):
        state.alert = .pleaseEnableContentBlocker
      case (true, false, false):
        state.alert = .updateSuccess
      case (true, _, _):
        break
      }

      state.isEnabledContentBlocker = isEnabled
      state.appLaunchCheck = false

      return .none

    case let .manuallyCheckUserEnableContentBlocker(isEnabled):
      state.alert = isEnabled ? .updateSuccess : .pleaseEnableContentBlocker
      state.isEnabledContentBlocker = isEnabled
      return .none

    case .tapDontTapMeButton:
      state.alert = AlertState(
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

      return .none

    case .tapRefreshButton:
      return checkUserEnabledContentBlocker(manually: true)

    case .tapAboutButton:
      return .none
    }
  }
}
