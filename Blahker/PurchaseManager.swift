//
//  PurchaseManager.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/12/4.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import StoreKit

enum ProductType: String {
    case tips1 = "com.elaborapp.Blahker.IAP.Tips1"
    case tips2 = "com.elaborapp.Blahker.IAP.Tips2"
    case tips3 = "com.elaborapp.Blahker.IAP.Tips3"
}

enum PurchaseManagerFailReason {
    case cantMakePayments
    case userCancelled
}

protocol PurchaseManagerDelegate {
    func purchaseFailed(productType: ProductType?, reason: PurchaseManagerFailReason)
    func purchaseSucceed(productType: ProductType?)
}

class PurchaseManager: NSObject, SKProductsRequestDelegate,  SKPaymentTransactionObserver {
    static let shared = PurchaseManager()
    var delegate: PurchaseManagerDelegate?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func startPurchase(productType: ProductType) {
        guard SKPaymentQueue.canMakePayments() else {
            self.delegate?.purchaseFailed(productType: productType, reason: .cantMakePayments)
            return
        }

        let productRequest = SKProductsRequest(productIdentifiers: [productType.rawValue])
        productRequest.delegate = self
        productRequest.start()
    }

    // MARK: SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }

    // MARK: SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                continue
            case .failed:
                queue.finishTransaction(transaction)

                let productType = ProductType(rawValue: transaction.payment.productIdentifier)
                self.delegate?.purchaseFailed(productType: productType, reason: .userCancelled)

            case .purchasing:
                continue
            case .purchased, .restored:
                queue.finishTransaction(transaction)

                let productType = ProductType(rawValue: transaction.payment.productIdentifier)
                self.delegate?.purchaseSucceed(productType: productType)
            @unknown default:
                break
            }
        }
    }
}
