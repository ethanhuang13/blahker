//
//  ContentBlockerService.swift
//
//
//  Created by Ethan Huang on 2023/11/5.
//

// import SafariServices
import Dependencies
import Foundation

public struct ContentBlockerService {
  public var checkUserEnabledContentBlocker: (String) async -> Bool
}

extension ContentBlockerService: DependencyKey {
  public static var liveValue = ContentBlockerService(
    checkUserEnabledContentBlocker: { bundleID in
//      SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExtensionIdentifier, completionHandler: { (state, error)
//      }
      true
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
