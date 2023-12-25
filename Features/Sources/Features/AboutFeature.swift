//
//  AboutFeature.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AboutFeature {
  struct State: Equatable {}

  enum Action: Equatable {
    case tapBlockerListCell
    case tapReportCell
    case tapRateCell
    case tapAboutCell
  }

  @Dependency(\.openURL) var openURL

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tapBlockerListCell:
      return .none
    case .tapReportCell:
      return .none
    case .tapRateCell:
      return .run { _ in
        await openURL(.appStore)
      }
    case .tapAboutCell:
      return .run { _ in
        await openURL(.github)
      }
    }
  }
}
