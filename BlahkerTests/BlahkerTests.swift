//
//  BlahkerTests.swift
//  BlahkerTests
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import Blahker

class BlahkerTests: XCTestCase {
    var rules: [Rule] = []
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testParseBlockerRules()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseBlockerRules() {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: "blockerList", withExtension: "json") else {
            fatalError("Missing file URL: blockerList.json")
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let rules = try JSONDecoder().decode([Rule].self, from: data)
            self.rules = rules
        } catch {
            XCTFail("Parse blockerList.json failed: \(error.localizedDescription)")
        }
    }
    
    func testRuleInternalLogic() {
        for rule in rules {
            XCTAssert(rule.trigger.urlFilter.isEmpty == false, "url-filter must not be empty.")
            XCTAssertFalse(rule.trigger.ifDomain != nil && rule.trigger.unlessDomain != nil, "Triggers cannot have both unless- and if-domain fields.")
            // TODO: Domain values must be lowercase ASCII. Use punycode to encode non-ASCII characters.
            XCTAssertFalse(rule.trigger.ifTopURL != nil && rule.trigger.unlessTopURL != nil, " Triggers cannot have both unless- and if-top-url fields.")

            if rule.action.type == .cssDisplayNone {
                XCTAssert(rule.action.selector != nil, "Selector is required when the action type is css-display-none.")
            }
        }
    }
}
