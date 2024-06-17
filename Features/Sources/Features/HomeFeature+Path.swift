//
//  HomeFeature+Path.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation

extension HomeFeature {
  @Reducer
  struct Path {
    @ObservableState
    enum State: Equatable {
      case about(AboutFeature.State)
      case blockerList(BlockerListFeature.State)
    }

    enum Action: Equatable {
      case about(AboutFeature.Action)
      case blockerList(BlockerListFeature.Action)
    }

    var body: some ReducerOf<Self> {
      Scope(state: \.about, action: \.about) {
        AboutFeature()
      }
      Scope(state: \.blockerList, action: \.blockerList) {
        BlockerListFeature()
      }
    }
  }
}
