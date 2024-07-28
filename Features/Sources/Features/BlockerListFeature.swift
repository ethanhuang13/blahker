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
    case receiveRuleItems([RuleItem])
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .task:
      return .run { send in
        @Dependency(\.urlSession) var urlSession
        let (data, _) = try await urlSession.data(from: URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json")!)
        let rules = try JSONDecoder().decode([Rule].self, from: data)
        await send(.receiveRuleItems([]))
      }
    case let .receiveRuleItems(ruleItems):
      state.ruleItems = ruleItems
      return .none
    }
  }
}

struct RuleItem: Equatable, Identifiable, Decodable {
  let id = UUID()

  var title: String
  var description: String
}
