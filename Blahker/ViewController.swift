//
//  ViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        #if DEBUG
            testContentBlockerRequestHandler()
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func testContentBlockerRequestHandler() {
        func success(withReturningItems returningItems: [NSExtensionItem]) {
            print("Complete request")
        }

        func failed(withError error: Error) {
            print("Failed")
        }

        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json") else {
            failed(withError: ContentBlockerRequestHandlerError.createBlockerListUrlFailed)
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, connectionError) -> Void in

            if let data = data,
                let string = String(data: data, encoding: .utf8) {
                print(string)
            }

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

