//
//  ContentBlockerRequestHandler.swift
//  Blocker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling, BlockerListLoader {
    var context: NSExtensionContext?

    func beginRequest(with context: NSExtensionContext) {
        self.context = context

        self.loadBlockerList()
    }

    func loadBlockerListSuccess(withReturningItems returningItems: [NSExtensionItem]) {
        self.context?.completeRequest(returningItems: returningItems, completionHandler: nil)
        print("Complete request")
    }

    func loadBlockerListFailed(withError error: Error) {
        self.context?.cancelRequest(withError: error)
        print("Failed")
    }
}
