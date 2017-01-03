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
    func loadBlockerList(completion: @escaping (([NSExtensionItem]?, Error?) -> Void))
}


fileprivate let blockerListUrl: URL? = {
    #if DEBUG
        return Bundle.main.url(forResource: "blockerList", withExtension: "json")
    #else
        return URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json")
    #endif
}()

extension BlockerListLoader {
    func loadBlockerList(completion: @escaping (([NSExtensionItem]?, Error?) -> Void)) {

        let session = URLSession(configuration: .default)
        guard let url = blockerListUrl else {
            completion(nil, ContentBlockerRequestHandlerError.createBlockerListUrlFailed)
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, connectionError) -> Void in
            guard let data = data as? NSSecureCoding else {
                completion(nil, ContentBlockerRequestHandlerError.loadBlockerListFileFailed)
                return
            }

            let attachment = NSItemProvider(item: data, typeIdentifier: kUTTypeJSON as String)
            let item = NSExtensionItem()
            item.attachments = [attachment]
            completion([item], nil)
        }

        task.resume()
    }
}
