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

    @IBAction func reloadButton(_ sender: Any) {
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
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
