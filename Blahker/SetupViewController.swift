//
//  SetupViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import SafariServices

class SetupViewController: UIViewController {
    private var isLoadingBlockerList: Bool = false {
        didSet {
            let isLoading = isLoadingBlockerList
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
                self.reloadButton.isEnabled = !isLoading
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        checkContentBlockerState()

        NotificationCenter.default.addObserver(self, selector: #selector(checkContentBlockerState), name: .UIApplicationDidBecomeActive, object: nil)
    }

    @objc private func checkContentBlockerState() {
        self.isLoadingBlockerList = true
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (state, error) -> Void in
            switch state?.isEnabled {
            case .some(true):
                SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (error) -> Void in
                    self.isLoadingBlockerList = false

                    if error == nil {
                        print("reloadContentBlocker complete")
                    } else {
                        print("reloadContentBlocker: \(error)")
                    }
                })
            default:
                self.isLoadingBlockerList = false

                let alertController = UIAlertController(title: "請開啟內容阻擋器", message: "請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "確定", style: .cancel, handler:  { (action) in
                    self.checkContentBlockerState()
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    @IBAction func reloadButton(_ sender: Any) {
        self.checkContentBlockerState()
    }

    @IBAction func aboutButton(_ sender: Any) {
        guard let url = URL(string: "https://github.com/ethanhuang13/blahker/blob/master/README.md") else { return }
        let vc = SFSafariViewController(url: url)
        vc.title = "關於"
        self.show(vc, sender: self)
    }

    @IBOutlet weak var reloadButton: UIBarButtonItem!
}
