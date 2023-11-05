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

struct AppFeature: Reducer {
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

struct AppView: View {
  let store: StoreOf<AppFeature>
  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    WithViewStore(store, observe: { $0.isEnabledContentBlocker }) { viewStore in
      let isEnabledContentBlocker = viewStore.state

      Text("Content Blocker is \(isEnabledContentBlocker ? "enabled" : "disabled")")
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
}
