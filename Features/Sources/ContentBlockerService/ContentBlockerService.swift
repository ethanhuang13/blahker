//
//  ContentBlockerService.swift
//
//
//  Created by Ethan Huang on 2023/11/5.
//

import Dependencies
import DependenciesMacros
import Foundation
import Models
import SafariServices

@DependencyClient
public struct ContentBlockerService {
  public var checkUserEnabledContentBlocker: (_ bundleID: String) async -> Bool = { _ in
    unimplemented("checkUserEnabledContentBlocker", placeholder: false)
  }

  public var reloadContentBlocker: (_ bundleID: String) async throws -> Void

  public var fetchBlockerList: () async throws -> [RuleItem]
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
    },
    fetchBlockerList: {
      // urlSession fetch file
      // decode [Rule]
      // convert to [RuleItem]
      // sort
      // return
      let urlSession = URLSession.shared
      let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json")!

      let (data, _) = try await urlSession.data(from: url)
      let rules = try JSONDecoder().decode([Rule].self, from: data)

      var rulesDict = [String: [String]]()

      for rule in rules {
        if let domains = rule.trigger.ifDomain,
           let selector = rule.action.selector {
          for domain in domains {
            var selectors = rulesDict[domain] ?? []
            selectors.append(selector)
            rulesDict[domain] = selectors
          }
        } else if let selector = rule.action.selector {
          var selectors = rulesDict["Any"] ?? []
          selectors.append(selector)
          rulesDict["Any"] = selectors
        }
      }

      var ruleItems = [RuleItem]()
      for (domain, selectors) in rulesDict {
        let ruleItem = RuleItem(domain: domain, selectors: selectors)
        ruleItems.append(ruleItem)
      }

      return ruleItems
        .sorted(using: [KeyPathComparator(\.domain)])
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
