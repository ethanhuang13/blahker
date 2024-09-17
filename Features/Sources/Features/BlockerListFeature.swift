//
//  BlockerListFeature.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation
import Models

@Reducer
struct BlockerListFeature {
  @ObservableState
  struct State: Equatable {
    var ruleItems: [RuleItem] = []
  }

  enum Action: Equatable {
    case task
    case reload
    case receiveRuleItems([RuleItem])
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    let fetchBlockerList: Effect<Action> =
      .run { send in
        @Dependency(\.contentBlockerService) var contentBlockerService
        let ruleItems = try await contentBlockerService.fetchBlockerList()
        await send(.receiveRuleItems(ruleItems))
      }

    switch action {
    case .task:
      return fetchBlockerList

    case .reload:
      return fetchBlockerList

    case let .receiveRuleItems(ruleItems):
      state.ruleItems = ruleItems
      return .none
    }
  }
}
