//
//  RuleItem.swift
//  Features
//
//  Created by ethanhuang on 2024/9/17.
//
import Foundation

public struct RuleItem: Equatable, Identifiable {
  public var id : String { domain }

  public var domain: String
  public var selectors: [String]

  public init(domain: String, selectors: [String]) {
    self.domain = domain
    self.selectors = selectors
  }
}
