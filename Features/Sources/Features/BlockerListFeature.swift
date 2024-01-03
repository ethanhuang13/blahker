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
  struct State: Equatable {
    var ruleItems: [RuleItem] = []
  }

  enum Action: Equatable {
    // case downloadBlockerList, ruleItems = rules.map {}
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}

struct RuleItem: Equatable, Identifiable {
  let id = UUID()

  var title: String
  var description: String
}
