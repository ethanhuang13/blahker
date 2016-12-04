//
//  SetupViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import SafariServices
import StoreKit

class SetupViewController: UIViewController {
    /// Use this flag to show alert after automatically reloading
    private var isLoadedFailedBefore = false

    /// Use this flag to show alert after manually reloading
    private var isReloadingManually = false

    /// Loading indicator and refresh button isEnabled toggling
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

        NotificationCenter.default.addObserver(self, selector: #selector(checkContentBlockerState), name: .UIApplicationWillEnterForeground, object: nil)
    }

    @objc private func checkContentBlockerState() {
        if let presentedVC = self.presentedViewController as? UIAlertController {
            presentedVC.dismiss(animated: true)
        }

        self.isLoadingBlockerList = true

        func reload() {
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (error) -> Void in
                DispatchQueue.main.async {
                    self.isLoadingBlockerList = false

                    if self.isReloadingManually || self.isLoadedFailedBefore {
                        self.isReloadingManually = false

                        let title = (error == nil) ? "更新成功" : "更新失敗"
                        let message = (error == nil) ? "已下載最新擋廣告網站清單" : "請檢查網路設定"
                        let feedbackType: UINotificationFeedbackType = (error == nil) ? .success : .error

                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "確定", style: .cancel, handler:  { (action) in }))
                        self.present(alertController, animated: true, completion: nil)


                        if #available(iOS 10.0, *) {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(feedbackType)
                        }
                    }

                    if error == nil {
                        print("reloadContentBlocker complete")
                        self.isLoadedFailedBefore = false
                    } else {
                        print("reloadContentBlocker: \(error)")
                        self.isLoadedFailedBefore = true
                    }
                }
            })
        }

        if #available(iOS 10.0, *) {
            SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (state, error) -> Void in
                DispatchQueue.main.async {
                    switch state?.isEnabled {
                    case .some(true):
                        reload()

                    default:
                        self.isLoadingBlockerList = false
                        self.isLoadedFailedBefore = true

                        let alertController = UIAlertController(title: "請開啟內容阻擋器", message: "請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "確定", style: .default, handler:  { (action) in
                            self.isReloadingManually = true
                            self.checkContentBlockerState()
                        }))
                        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)

                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                    }
                }
            })
        } else {
            reload()
        }
    }

    @IBAction func reloadButton(_ sender: Any) {
        isReloadingManually = true
        self.checkContentBlockerState()
    }

    @IBAction func donateButton(_ sender: Any) {
        PurchaseManager.shared.delegate = self

        let alertController = UIAlertController(title: "支持開發者", message: "Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "打賞小小費", style: .default, handler:  { (action) in
            PurchaseManager.shared.startPurchase(productType: .tips1)
        }))

        alertController.addAction(UIAlertAction(title: "打賞小費", style: .default, handler:  { (action) in
            PurchaseManager.shared.startPurchase(productType: .tips2)
        }))

        alertController.addAction(UIAlertAction(title: "破費", style: .default, handler:  { (action) in
            PurchaseManager.shared.startPurchase(productType: .tips3)
        }))

        alertController.addAction(UIAlertAction(title: "我不出錢，給個五星評分總行了吧", style: .default, handler:  { (action) in
            guard let url = URL(string: "https://itunes.apple.com/us/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?l=zh&ls=1&mt=8&at=1l3vpBq&pt=99170802&ct=inappnotdonate") else { return }
            UIApplication.shared.openURL(url)
        }))

        alertController.addAction(UIAlertAction(title: "算了吧，不值得", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tutorialLabel: UILabel!
}

extension SetupViewController: PurchaseManagerDelegate {
    func purchaseSucceed(productType: ProductType?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "打賞成功！", message: "感激不盡，Blahker 有你的支持將會越來越好", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "不客氣", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func purchaseFailed(productType: ProductType?, reason: PurchaseManagerFailReason) {
        DispatchQueue.main.async {
            switch reason {
            case .userCancelled: break
            case .cantMakePayments:
                let alertController = UIAlertController(title: "唉呀", message: "謝謝你，但是你沒有辦法付費耶。請檢查 iTunes 帳號的付費權限喔", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "好吧", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
