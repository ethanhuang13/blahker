//
//  AboutFeature.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AboutFeature {
  struct State: Equatable {
    @PresentationState var alert: AlertState<Action.Alert>?
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case presentPleaseEnableiOSMailAlert
    case tapBlockerListCell
    case tapReportCell
    case tapRateCell
    case tapAboutCell

    enum Alert {
      case ok
    }
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.mailComposeClient) var mailComposeClient

  var body: some ReducerOf<Self> {
    Reduce(core)
      .ifLet(\.$alert, action: \.alert)
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case let .alert(.presented(alert)):
      switch alert {
      case .ok:
        return .none
      }

    case .alert(.dismiss):
      return .none

    case .presentPleaseEnableiOSMailAlert:
      state.alert = .pleaseEnableiOSMail
      return .none

    case .tapBlockerListCell:
      return .none
    case .tapReportCell:
      return .run { send in
        if mailComposeClient.canSendMail() {
          // TODO
        } else {
          await send(.presentPleaseEnableiOSMailAlert)
        }
      }
    case .tapRateCell:
      return .run { _ in
        await openURL(.appStore)
      }
    case .tapAboutCell:
      return .run { _ in
        await openURL(.github)
      }
    }
  }
}
