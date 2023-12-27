//
//  HomeFeature+Alert.swift
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

  static var donation: Self {
    AlertState(
      title: TextState("支持開發者"),
      message: TextState("Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～"),
      buttons: [
        ButtonState(
          action: .smallDonation,
          label: {
            TextState("打賞小小費")
          }
        ),
        ButtonState(
          action: .mediumDonation,
          label: {
            TextState("打賞小費")
          }
        ),
        ButtonState(
          action: .largeDonation,
          label: {
            TextState("破費")
          }
        ),
        ButtonState(
          action: .rate5Star,
          label: {
            TextState("我不出錢，給個五星評分總行了吧")
          }
        ),
        ButtonState(
          role: .cancel,
          label: {
            TextState("算了吧，不值得")
          }
        )
      ]
    )
  }
}
