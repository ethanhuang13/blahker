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

enum PurchaseManagerFailReason: Error {
    case cantMakePayments
    case failure(underlyingError: Error)
    case userCancelled
}

typealias PurchaseCompletion = (Result<Void, PurchaseManagerFailReason>) -> Void

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = PurchaseManager()
    private var completion: PurchaseCompletion?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func startPurchase(productType: ProductType, completion: @escaping PurchaseCompletion) {
        self.completion = completion
        guard SKPaymentQueue.canMakePayments() else {
            completion(.failure(.cantMakePayments))
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
                if let error = transaction.error as? SKError,
                   error.code != SKError.Code.paymentCancelled {
                    let reason = PurchaseManagerFailReason.failure(underlyingError: error)
                    completion?(.failure(reason))
                } else {
                    let reason = PurchaseManagerFailReason.userCancelled
                    completion?(.failure(reason))
                }
                
            case .purchasing:
                continue
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                completion?(.success(()))
            @unknown default:
                break
            }
        }
    }
}
