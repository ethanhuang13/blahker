//
//  SafariService.swift
//
//
//  Created by Ethan Huang on 2023/11/5.
//

import Foundation
//import SafariServices
import Dependencies

struct ContentBlockerService {
  var checkUserEnabledContentBlocker: (String) async -> Bool
}

extension ContentBlockerService: DependencyKey {
  static var liveValue = ContentBlockerService(
    checkUserEnabledContentBlocker: { bundleID in
//      SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExtensionIdentifier, completionHandler: { (state, error)
//      }
      return true
    }
  )
}

extension ContentBlockerService: TestDependencyKey {
  static var testValue = ContentBlockerService(
    checkUserEnabledContentBlocker: unimplemented("checkUserEnabledContentBlocker")
  )
}

extension DependencyValues {
  var contentBlockerService: ContentBlockerService {
    get { self[ContentBlockerService.self] }
    set { self[ContentBlockerService.self] = newValue }
  }
}
