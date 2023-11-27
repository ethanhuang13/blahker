import ComposableArchitecture
import ContentBlockerService
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

@Reducer
struct AppFeature {
  struct State: Equatable {
    var home: HomeFeature.State = .init()
  }

  enum Action: Equatable {
    case home(HomeFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.home, action: \.home) {
      HomeFeature()
    }

    Reduce(core)
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .home:
      return .none
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    HomeView(store: store.scope(state: \.home, action: \.home))
  }
}
