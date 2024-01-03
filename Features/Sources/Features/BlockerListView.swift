//
//  BlockerListView.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct BlockerListView: View {
  let store: StoreOf<BlockerListFeature>

  var body: some View {
    WithViewStore(store, observe: \.ruleItems) { viewStore in
      let ruleItems = viewStore.state

      List {
        ForEach(ruleItems) { ruleItem in
          VStack(alignment: .leading) {
            Text(ruleItem.title)
              .font(.headline)
              .lineLimit(1)
            Text(ruleItem.description)
              .font(.subheadline)
              .lineLimit(3)
              .foregroundStyle(.secondary)
          }
        }
      }
      .navigationTitle(Text("已阻擋的蓋版廣告網站"))
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  NavigationStack {
    BlockerListView(
      store: .init(
        initialState: BlockerListFeature.State(
          ruleItems: [.init(title: "*4gamers.com.tw", description: ".iframe-ads-link")]
        ),
        reducer: { BlockerListFeature() }
      )
    )
  }
  .preferredColorScheme(.dark)
}
