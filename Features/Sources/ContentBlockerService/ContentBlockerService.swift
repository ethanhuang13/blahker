//
//  ContentBlockerService.swift
//
//
//  Created by Ethan Huang on 2023/11/5.
//

import Dependencies
import DependenciesMacros
import Foundation
import SafariServices

@DependencyClient
public struct ContentBlockerService {
  public var checkUserEnabledContentBlocker: (String) async -> Bool = { _ in
    unimplemented("checkUserEnabledContentBlocker")
  }

  public var reloadContentBlocker: (String) async throws -> Void
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
    },
    reloadContentBlocker: { bundleID in
      try await withCheckedThrowingContinuation { continuation in
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: bundleID, completionHandler: { error in
          if let error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume()
          }
        })
      }
    }
  )
}

extension ContentBlockerService: TestDependencyKey {
  public static var testValue = ContentBlockerService()
}

public extension DependencyValues {
  var contentBlockerService: ContentBlockerService {
    get { self[ContentBlockerService.self] }
    set { self[ContentBlockerService.self] = newValue }
  }
}
