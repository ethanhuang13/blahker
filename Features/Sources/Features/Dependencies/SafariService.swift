//
//  SafariService.swift
//
//
//  Created by Ethan Huang on 2023/11/5.
//

import Foundation
//import SafariServices
import Dependencies

struct SafariService {
  var checkUserEnabledContentBlocker: (String) async -> Bool
}

extension SafariService: DependencyKey {
  static var liveValue = SafariService(
    checkUserEnabledContentBlocker: { bundleID in
//      SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExtensionIdentifier, completionHandler: { (state, error)
//      }
      return true
    }
  )
}

extension SafariService: TestDependencyKey {
  static var testValue = SafariService(
    checkUserEnabledContentBlocker: unimplemented("checkUserEnabledContentBlocker")
  )
}

extension DependencyValues {
  var safariService: SafariService {
    get { self[SafariService.self] }
    set { self[SafariService.self] = newValue }
  }
}
