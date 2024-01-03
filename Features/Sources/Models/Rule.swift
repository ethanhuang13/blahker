//
//  Rule.swift
//  Blahker
//
//  Created by Ethanhuang on 2018/8/5.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

// Spec https://developer.apple.com/library/archive/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html#//apple_ref/doc/uid/TP40016265-CH2-SW1

public struct Rule: Codable, Equatable {
  public let trigger: Trigger
  public let action: Action

  public struct Trigger: Codable, Equatable {
    public let urlFilter: String
    public let urlFilterIsCaseSenstive: Bool?

    public let ifDomain: [String]?
    public let unlessDomain: [String]?

    public let resourceType: [ResourceType]?
    public let loadType: [LoadType]?

    public let ifTopURL: [String]?
    public let unlessTopURL: [String]?

    public enum CodingKeys: String, CodingKey {
      case urlFilter = "url-filter"
      case urlFilterIsCaseSenstive = "url-filter-is-case-sensitive"
      case ifDomain = "if-domain"
      case unlessDomain = "unless-domain"
      case resourceType = "resource-type"
      case loadType = "load-type"
      case ifTopURL = "if-top-url"
      case unlessTopURL = "unless-top-url"
    }

    public enum ResourceType: String, Codable, Equatable {
      case document
      case image
      case styleSheet = "style-sheet"
      case script
      case font
      case raw
      case svg = "svg-document"
      case media
      case popup
    }

    public enum LoadType: String, Codable, Equatable {
      case firstParty = "first-party"
      case thirdParty = "third-party"
    }
  }

  public struct Action: Codable, Equatable {
    public let type: ActionType
    public let selector: String?

    public enum ActionType: String, Codable {
      case block
      case blockCookies = "block-cookies"
      case cssDisplayNone = "css-display-none"
      case ignorePreviousRules = "ignore-previous-rules"
      case makeHttps = "make-https"
    }
  }
}
