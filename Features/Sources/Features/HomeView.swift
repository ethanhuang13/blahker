//
//  HomeView.swift
//
//
//  Created by Ethan Huang on 2023/11/22.
//

import ComposableArchitecture
import SwiftUI

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
      case smallDonation
      case mediumDonation
      case largeDonation
      case rate5Star
    }
  }

  @Dependency(\.contentBlockerService) var contentBlockerService

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    var checkUserEnabledContentBlocker: Effect<Action> {
      .run { send in
        let extensionID = "com.elaborapp.Blahker.ContentBlocker"
        let isEnabled = await contentBlockerService.checkUserEnabledContentBlocker(extensionID)
        await send(.userEnableContentBlocker(isEnabled))
      }
    }

    switch action {
    case let .alert(.presented(alert)):
      switch alert {
      case .smallDonation:
        return .none
      case .mediumDonation:
        return .none
      case .largeDonation:
        return .none
      case .rate5Star:
        return .none
      }

    case .alert(.dismiss):
      return .none

    case .scenePhaseBecomeActive:
      return checkUserEnabledContentBlocker

    case let .userEnableContentBlocker(isEnabled):
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
          })
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

struct HomeView: View {
  let store: StoreOf<HomeFeature>

  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationStack {
        VStack {
          setupDescription
          Spacer()
          dontTapMeButton
        }
        .navigationTitle("Blahker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            refreshButton
          }
          ToolbarItem(placement: .topBarTrailing) {
            aboutButton
          }
        }
        .onChange(of: scenePhase) { phase in
          switch phase {
          case .active:
            store.send(.scenePhaseBecomeActive)
          case .background, .inactive:
            break
          @unknown default:
            break
          }
        }
      }
      .preferredColorScheme(.dark)
    }
  }

  @MainActor
  @ViewBuilder
  private var setupDescription: some View {
    Text("""
    Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。

    App 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。

    欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。
    """)
    .padding()
  }

  @MainActor
  @ViewBuilder
  private var dontTapMeButton: some View {
    Button(
      action: {
        store.send(.tapDontTapMeButton)
      },
      label: {
        Text("拜託別按我")
      }
    )
    .foregroundStyle(Color.white)
    .font(.title)
    .alert(store: store.scope(state: \.$alert, action: \.alert))
  }

  @MainActor
  @ViewBuilder
  private var refreshButton: some View {
    Button(
      action: {
        store.send(.tapRefreshButton)
      },
      label: {
        Image(systemName: "arrow.clockwise")
      }
    )
    .buttonStyle(.plain)
  }

  @MainActor
  @ViewBuilder
  private var aboutButton: some View {
    Button(
      action: {
        store.send(.tapAboutButton)
      },
      label: {
        Text("關於")
      }
    )
    .buttonStyle(.plain)
  }
}

#Preview {
  HomeView(store: .init(
    initialState: HomeFeature.State(),
    reducer: { HomeFeature() }
  ))
}
