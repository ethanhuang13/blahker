//
//  HomeFeature+Extension.swift
//
//
//  Created by Ethan Huang on 2023/12/10.
//

import ComposableArchitecture
import Foundation

extension AlertState<HomeFeature.Action.Alert> {
  static var pleaseEnableContentBlocker: Self {
    AlertState<HomeFeature.Action.Alert>(
      title: TextState("請開啟內容阻擋器"),
      message: TextState("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker"),
      buttons: [
        ButtonState(
          action: .okToReloadContentBlocker,
          label: {
            TextState("確定")
          }
        ),
        ButtonState(
          role: .cancel,
          label: {
            TextState("取消")
          }
        )
      ]
    )
  }

  static var updateSuccess: Self {
    AlertState(
      title: TextState("更新成功"),
      message: TextState("已下載最新擋廣告網站清單"),
      buttons: [
        ButtonState(
          role: .cancel,
          label: {
            TextState("確定")
          }
        ),
      ]
    )
  }
}
