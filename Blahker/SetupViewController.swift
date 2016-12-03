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

        checkContentBlockerState()

        // iOS 10 can detect content blocker exteiosn status
        if #available(iOS 10.0, *) {
            tutorialLabel.text = "Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。"
                + "\n\nApp 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。"
                + "\n\n欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。"
        } else {
            tutorialLabel.text = "Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。"
                + "\n\n請確定「設定」 > 「Safari」 > 「內容阻擋器」，已經啟用 Blahker。"
                + "\n\nApp 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。"
                + "\n\n欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。"
        }

        NotificationCenter.default.addObserver(self, selector: #selector(checkContentBlockerState), name: .UIApplicationDidBecomeActive, object: nil)
    }

    @objc private func checkContentBlockerState() {
        self.isLoadingBlockerList = true

        func reload() {
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (error) -> Void in
                self.isLoadingBlockerList = false

                if error == nil {
                    print("reloadContentBlocker complete")
                } else {
                    print("reloadContentBlocker: \(error)")
                }
            })
        }

        if #available(iOS 10.0, *) {
            SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (state, error) -> Void in
                switch state?.isEnabled {
                case .some(true):
                    reload()

                default:
                    self.isLoadingBlockerList = false
                    
                    let alertController = UIAlertController(title: "請開啟內容阻擋器", message: "請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: .default, handler:  { (action) in
                        self.checkContentBlockerState()
                    }))
                    alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        } else {
            reload()
        }
    }

    @IBAction func reloadButton(_ sender: Any) {
        self.checkContentBlockerState()
    }

    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tutorialLabel: UILabel!
}
