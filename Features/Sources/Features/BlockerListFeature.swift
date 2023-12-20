//
//  BlockerListFeature.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BlockerListFeature {
  struct State: Equatable {}

  enum Action: Equatable {}

  func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}
