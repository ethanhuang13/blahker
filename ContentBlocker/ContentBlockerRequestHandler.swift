//
//  ContentBlockerRequestHandler.swift
//  Blocker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        func success(withReturningItems returningItems: [NSExtensionItem]) {
            context.completeRequest(returningItems: returningItems, completionHandler: nil)
            print("Complete request")
        }

        func failed(withError error: Error) {
            context.cancelRequest(withError: error)
            print("Failed")
        }
        
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json") else {
            failed(withError: ContentBlockerRequestHandlerError.createBlockerListUrlFailed)
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, connectionError) -> Void in
            guard let data = data as? NSSecureCoding else {
                failed(withError: ContentBlockerRequestHandlerError.loadBlockerListFileFailed)
                return
            }

            let attachment = NSItemProvider(item: data, typeIdentifier: kUTTypeJSON as String)
            let item = NSExtensionItem()
            item.attachments = [attachment]
            success(withReturningItems: [item])
        }
        
        task.resume()
    }
}
