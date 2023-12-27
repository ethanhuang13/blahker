//
//  MailComposeClient.swift
//
//
//  Created by ethanhuang on 2023/12/27.
//

import Dependencies
import DependenciesMacros
import Foundation
import MessageUI

@DependencyClient
struct MailComposeClient {
  var canSendMail: () -> Bool = {
    unimplemented("canSendMail", placeholder: false)
  }
}

extension MailComposeClient: DependencyKey {
  static var liveValue = MailComposeClient(
    canSendMail: {
      MFMailComposeViewController.canSendMail()
    }
  )
}

extension DependencyValues {
  var mailComposeClient: MailComposeClient {
    get { self[MailComposeClient.self] }
    set { self[MailComposeClient.self] = newValue }
  }
}
