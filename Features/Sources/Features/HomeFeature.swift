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
  @ObservableState
  struct State: Equatable {
    var appLaunchCheck = true
    var isEnabledContentBlocker = false
    var isCheckingBlockerList = false

    @Presents var alert: AlertState<Action.Alert>?
    var path = StackState<Path.State>()
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case path(StackAction<Path.State, Path.Action>)
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
      .forEach(\.path, action: \.path) {
        Path()
      }
      .ifLet(\.$alert, action: \.alert)
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {
    func checkUserEnabledContentBlockerAndReload(manually: Bool) -> Effect<Action> {
      state.isCheckingBlockerList = true
      return .run { send in
        let bundleID = "com.elaborapp.Blahker.ContentBlocker"
        let isEnabled = await contentBlockerService.checkUserEnabledContentBlocker(bundleID)

        if isEnabled {
          try await contentBlockerService.reloadContentBlocker(bundleID)
        }

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
        return checkUserEnabledContentBlockerAndReload(manually: true)
      case .smallDonation:
        return .none
      case .mediumDonation:
        return .none
      case .largeDonation:
        return .none
      case .rate5Star:
        return .run { _ in
          await openURL(.appStore)
        }
      }

    case .alert(.dismiss):
      return .none

    case .path(.element(id: _, action: .about(.tapBlockerListCell))):
      state.path.append(.blockerList(.init()))
      return .none

    case .path:
      return .none

    case .appDidFinishLaunching:
      return checkUserEnabledContentBlockerAndReload(manually: false)

    case .scenePhaseBecomeActive:
      return checkUserEnabledContentBlockerAndReload(manually: false)

    case let .userEnableContentBlocker(isEnabled):
      switch (isEnabled, state.appLaunchCheck, state.isEnabledContentBlocker) {
      case (false, _, _):
        state.alert = .pleaseEnableContentBlocker
      case (true, false, false):
        state.alert = .updateSuccess
      case (true, _, _):
        break
      }

      state.isCheckingBlockerList = false
      state.isEnabledContentBlocker = isEnabled
      state.appLaunchCheck = false

      return .none

    case let .manuallyCheckUserEnableContentBlocker(isEnabled):
      state.isCheckingBlockerList = false
      state.alert = isEnabled ? .updateSuccess : .pleaseEnableContentBlocker
      state.isEnabledContentBlocker = isEnabled
      return .none

    case .tapDontTapMeButton:
      state.alert = .donation
      return .none

    case .tapRefreshButton:
      return checkUserEnabledContentBlockerAndReload(manually: true)

    case .tapAboutButton:
      state.path.append(.about(.init()))
      return .none
    }
  }
}
