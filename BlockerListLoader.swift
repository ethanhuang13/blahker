//
//  BlockerListLoader.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/12/1.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import MobileCoreServices

protocol BlockerListLoader {
    func loadBlockerList()
    func loadBlockerListSuccess(withReturningItems returningItems: [NSExtensionItem])
    func loadBlockerListFailed(withError error: Error)
}

extension BlockerListLoader {
    func loadBlockerList() {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json") else {
            loadBlockerListFailed(withError: ContentBlockerRequestHandlerError.createBlockerListUrlFailed)
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, connectionError) -> Void in
            guard let data = data as? NSSecureCoding else {
                self.loadBlockerListFailed(withError: ContentBlockerRequestHandlerError.loadBlockerListFileFailed)
                return
            }

            let attachment = NSItemProvider(item: data, typeIdentifier: kUTTypeJSON as String)
            let item = NSExtensionItem()
            item.attachments = [attachment]
            self.loadBlockerListSuccess(withReturningItems: [item])
        }

        task.resume()
    }
}
