//
//  Rule.swift
//  Blahker
//
//  Created by Ethanhuang on 2018/8/5.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

// Spec https://developer.apple.com/library/archive/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html#//apple_ref/doc/uid/TP40016265-CH2-SW1

struct Rule: Codable {
    let trigger: Trigger
    let action: Action

    struct Trigger: Codable {
        let urlFilter: String
        let urlFilterIsCaseSenstive: Bool?

        let ifDomain: [String]?
        let unlessDomain: [String]?

        let resourceType: [ResourceType]?
        let loadType: [LoadType]?

        let ifTopURL: [String]?
        let unlessTopURL: [String]?

        enum CodingKeys: String, CodingKey {
            case urlFilter = "url-filter"
            case urlFilterIsCaseSenstive = "url-filter-is-case-sensitive"
            case ifDomain = "if-domain"
            case unlessDomain = "unless-domain"
            case resourceType = "resource-type"
            case loadType = "load-type"
            case ifTopURL = "if-top-url"
            case unlessTopURL = "unless-top-url"
        }

        enum ResourceType: String, Codable {
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

        enum LoadType: String, Codable {
            case firstParty = "first-party"
            case thirdParty = "third-party"
        }
    }

    struct Action: Codable {
        let type: ActionType
        let selector: String?

        enum ActionType: String, Codable {
            case block
            case blockCookies = "block-cookies"
            case cssDisplayNone = "css-display-none"
            case ignorePreviousRules = "ignore-previous-rules"
            case makeHttps = "make-https"
        }
    }
}
