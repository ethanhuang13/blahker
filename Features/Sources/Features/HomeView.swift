//
//  HomeView.swift
//
//
//  Created by Ethan Huang on 2023/11/22.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
  let store: StoreOf<HomeFeature>

  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    NavigationStackStore(
      store.scope(state: \.path, action: \.path),
      root: {
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
      },
      destination: { state in
        switch state {
        case .about:
          CaseLet(
            /HomeFeature.Path.State.about,
            action: HomeFeature.Path.Action.about
          ) {
            AboutView(store: $0)
          }
        case .blockerList:
          CaseLet(
            /HomeFeature.Path.State.blockerList,
            action: HomeFeature.Path.Action.blockerList
          ) {
            BlockerListView(store: $0)
          }
        }
      }
    )
    .preferredColorScheme(.dark)
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
