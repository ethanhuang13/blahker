import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class AppFeatureTests: XCTestCase {
  func testAppLaunch() async throws {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: { AppFeature() }
    )
  }
}
