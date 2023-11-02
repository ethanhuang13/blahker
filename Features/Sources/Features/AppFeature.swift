import ComposableArchitecture
import SwiftUI

@main
struct BlahkerApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
      ))
    }
  }
}

struct AppFeature: Reducer {
  struct State: Equatable {}

  enum Action: Equatable {
    case scenePhaseBecomeActive
    case checkUserEnabledContentBlocker
    case userEnableContentBlocker(Bool)
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .scenePhaseBecomeActive:
      return .send(.checkUserEnabledContentBlocker)
    case .checkUserEnabledContentBlocker:
      return .send(.userEnableContentBlocker(false))
    case .userEnableContentBlocker(let bool):
      return .none
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>
  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    Text("Blahker")
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
}
