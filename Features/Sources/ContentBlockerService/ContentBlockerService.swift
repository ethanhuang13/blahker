//
//  ContentBlockerService.swift
//
//
//  Created by Ethan Huang on 2023/11/5.
//

import Dependencies
import Foundation
import SafariServices

public struct ContentBlockerService {
  public var checkUserEnabledContentBlocker: (String) async -> Bool
}

extension ContentBlockerService: DependencyKey {
  public static var liveValue = ContentBlockerService(
    checkUserEnabledContentBlocker: { bundleID in
      await withCheckedContinuation { continuation in
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID) { state, error in
          if let error {
            // log
          }
          continuation.resume(returning: state?.isEnabled ?? false)
        }
      }
    }
  )
}

extension ContentBlockerService: TestDependencyKey {
  public static var testValue = ContentBlockerService(
    checkUserEnabledContentBlocker: unimplemented("checkUserEnabledContentBlocker")
  )
}

public extension DependencyValues {
  var contentBlockerService: ContentBlockerService {
    get { self[ContentBlockerService.self] }
    set { self[ContentBlockerService.self] = newValue }
  }
}
