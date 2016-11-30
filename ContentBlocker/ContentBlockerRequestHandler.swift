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
    func beginRequest(with context: NSExtensionContext) {
        self.loadBlockerList { (items, error) in
            if let items = items {
                context.completeRequest(returningItems: items, completionHandler: { (expired) in
                    print("loadBlockerList: Complete request")
                })
            } else if let error = error {
                context.cancelRequest(withError: error)
                print("loadBlockerList failed: \(error)")
            }
        }
    }
}
