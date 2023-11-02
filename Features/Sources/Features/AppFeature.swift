import ComposableArchitecture
import SwiftUI

@main
struct BlahkerApp: App {
  var body: some Scene {
    WindowGroup {
      Text("Blahker")
    }
  }
}

struct AppFeature: Reducer {
  struct State: Equatable {}

  enum Action: Equatable {}

  func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}
