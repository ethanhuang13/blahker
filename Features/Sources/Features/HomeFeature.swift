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
    var isEnabledContentBlocker = false
    @PresentationState var alert: AlertState<Action.Alert>?
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case scenePhaseBecomeActive
    case userEnableContentBlocker(Bool)
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
    var checkUserEnabledContentBlocker: Effect<Action> {
      .run { send in
        let extensionID = "com.elaborapp.Blahker.ContentBlocker"
        let isEnabled = await contentBlockerService.checkUserEnabledContentBlocker(extensionID)
        await send(.userEnableContentBlocker(isEnabled))
      }
    }

    let pleaseEnableContentBlockerAlert = AlertState<HomeFeature.Action.Alert>(
      title: TextState("請開啟內容阻擋器"),
      message: TextState("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker"),
      buttons: [
        ButtonState(
          action: .okToReloadContentBlocker,
          label: {
            TextState("確定")
          }
        ),
        ButtonState(
          role: .cancel,
          label: {
            TextState("取消")
          }
        )
      ]
    )

    switch action {
    case let .alert(.presented(alert)):
      switch alert {
      case .okToReloadContentBlocker:
        state.alert = pleaseEnableContentBlockerAlert
        return .none
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

    case .scenePhaseBecomeActive:
      return checkUserEnabledContentBlocker

    case let .userEnableContentBlocker(isEnabled):
      state.isEnabledContentBlocker = isEnabled

      if isEnabled {
      } else {
        state.alert = pleaseEnableContentBlockerAlert
      }

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
      return checkUserEnabledContentBlocker

    case .tapAboutButton:
      return .none
    }
  }
}
