//
//  HomeFeature+Path.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation

extension HomeFeature {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case about(AboutFeature)
    case blockerList(BlockerListFeature)
  }
}
