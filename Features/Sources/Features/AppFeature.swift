import ComposableArchitecture
import ContentBlockerService
import SwiftUI

@main
struct BlahkerApp: App {
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  let store: StoreOf<AppFeature> = Store(
    initialState: AppFeature.State(),
    reducer: { AppFeature() }
  )

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    store.send(.home(.appDidFinishLaunching))
    return true
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
