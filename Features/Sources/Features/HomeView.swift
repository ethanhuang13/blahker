//
//  HomeView.swift
//
//
//  Created by Ethan Huang on 2023/11/22.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationStack {
      VStack {
        setupDescription
        Spacer()
        dontTapMeButton
      }
      .navigationTitle("Blahker")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          refreshButton
        }
        ToolbarItem(placement: .topBarTrailing) {
          aboutButton
        }
      }
    }
    .preferredColorScheme(.dark)
  }

  @MainActor
  @ViewBuilder
  private var setupDescription: some View {
    Text("""
    Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。

    App 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。

    欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。
    """)
    .padding()
  }

  @MainActor
  @ViewBuilder
  private var dontTapMeButton: some View {
    Button(
      action: {
        // TODO: send action
      },
      label: {
        Text("拜託別按我")
      }
    )
    .foregroundStyle(Color.white)
    .font(.title)
  }

  @MainActor
  @ViewBuilder
  private var refreshButton: some View {
    Button(
      action: {
        // TODO: send action
      },
      label: {
        Image(systemName: "arrow.clockwise")
      }
    )
    .buttonStyle(.plain)
  }

  @MainActor
  @ViewBuilder
  private var aboutButton: some View {
    Button(
      action: {
        // TODO: send action
      },
      label: {
        Text("關於")
      }
    )
    .buttonStyle(.plain)
  }
}

#Preview {
  HomeView()
}
