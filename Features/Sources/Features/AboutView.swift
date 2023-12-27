//
//  AboutView.swift
//
//
//  Created by Ethan Huang on 2023/12/21.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct AboutView: View {
  let store: StoreOf<AboutFeature>

  var body: some View {
    List {
      Section {
        blockerListCell
        reportCell
      }
      Section {
        rateCell
        shareCell
        aboutCell
      }
    }
    .navigationTitle(Text("關於"))
    .navigationBarTitleDisplayMode(.inline)
  }

  @MainActor
  @ViewBuilder
  private var blockerListCell: some View {
    Button(
      action: {
        store.send(.tapBlockerListCell)
      },
      label: {
        Text("已阻擋的蓋版廣告網站")
      }
    )
  }

  @MainActor
  @ViewBuilder
  private var reportCell: some View {
    Button(
      action: {
        store.send(.tapReportCell)
      },
      label: {
        VStack(alignment: .leading) {
          Text("回報廣告網站或問題")
          Text("請附上螢幕截圖，以利判斷")
            .font(.footnote)
        }
      }
    )
  }

  @MainActor
  @ViewBuilder
  private var rateCell: some View {
    Button(
      action: {
        store.send(.tapRateCell)
      },
      label: {
        Text("為我們評分")
      }
    )
  }

  @MainActor
  @ViewBuilder
  private var shareCell: some View {
    ShareLink(item: .appStore) {
      Text("推薦給朋友")
    }
  }

  @MainActor
  @ViewBuilder
  private var aboutCell: some View {
    Button(
      action: {
        store.send(.tapAboutCell)
      },
      label: {
        VStack(alignment: .leading) {
          Text("關於 Blahker 與常見問題")
          Text("v1.1.0(12)")
            .font(.footnote)
        }
      }
    )
  }
}

#Preview {
  NavigationStack {
    AboutView(
      store: .init(
        initialState: AboutFeature.State(),
        reducer: {
          AboutFeature()
        }
      )
    )
  }
  .preferredColorScheme(.dark)
}
