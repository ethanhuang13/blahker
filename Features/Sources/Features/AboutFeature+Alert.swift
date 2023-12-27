//
//  AboutFeature+Alert.swift
//
//
//  Created by ethanhuang on 2023/12/27.
//

import ComposableArchitecture
import Foundation

extension AlertState<AboutFeature.Action.Alert> {
  static var pleaseEnableiOSMail: Self {
    AlertState<AboutFeature.Action.Alert>(
      title: TextState("請先啟用 iOS 郵件"),
      message: TextState("""
      請先至 iOS 郵件 app 登入信箱，或寄信到 elaborapp+blahker@gmail.com
      """),
      buttons: [
        ButtonState(
          role: .cancel,
          label: {
            TextState("確定")
          }
        )
      ]
    )
  }
}
