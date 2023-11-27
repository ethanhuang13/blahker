//
//  HomeView.swift
//
//
//  Created by Ethan Huang on 2023/11/22.
//

import ComposableArchitecture
import SwiftUI

struct HomeFeature: Reducer {
  struct State: Equatable {
    var isEnabledContentBlocker = false
  }

  enum Action: Equatable {
    case scenePhaseBecomeActive
    case checkUserEnabledContentBlocker
    case userEnableContentBlocker(Bool)
  }

  @Dependency(\.contentBlockerService) var contentBlockerService

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .scenePhaseBecomeActive:
      return .send(.checkUserEnabledContentBlocker)

    case .checkUserEnabledContentBlocker:
      return .run { send in
        let extensionID = "com.elaborapp.Blahker.ContentBlocker"
        let isEnabled = await contentBlockerService.checkUserEnabledContentBlocker(extensionID)
        await send(.userEnableContentBlocker(isEnabled))
      }

    case let .userEnableContentBlocker(isEnabled):
      state.isEnabledContentBlocker = isEnabled
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
        // TODO: send action
      },
      label: {
        Text("拜託別按我")
      }
    )
    .foregroundStyle(Color.white)
    .font(.title)
  }

  @MainActor
  @ViewBuilder
  private var refreshButton: some View {
    Button(
      action: {
        // TODO: send action
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
        // TODO: send action
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
