//
//  IAPService.swift
//  MagnetHockey
//
//  Created by Wysong, Trevor on 4/30/20.
//  Copyright © 2020 Wysong, Trevor. All rights reserved.
//

import StoreKit

class IAPService: NSObject
{
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts()
    {
        let products: Set = [IAPProducts.purchaseBlackBall.rawValue,
                             IAPProducts.removeAds.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProducts)
    {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases()
    {
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)
    {
        products = response.products
        for product in response.products
        {
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver
{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transaction in transactions
        {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            print(transaction.payment.productIdentifier)
            
            switch transaction.transactionState
            {
            case .purchasing: break
            case .purchased: if (transaction.payment.productIdentifier == "com.TrevorWysong.MagnetHockeyGame.PurchaseBlackBall") && (transaction.transactionState.status() == "purchased")
            {
                let save = UserDefaults.standard
                save.set(true, forKey: "PurchaseBlackBall")
                save.synchronize()
            }
            if (transaction.payment.productIdentifier == "com.TrevorWysong.MagnetHockeyGame.RemoveAds")
            {
                let save = UserDefaults.standard
                save.set(true, forKey: "Purchase")
                save.synchronize()
            }
            case .restored: if (transaction.payment.productIdentifier == "com.TrevorWysong.MagnetHockeyGame.PurchaseBlackBall")
            {
                let save = UserDefaults.standard
                save.set(true, forKey: "PurchaseBlackBall")
                save.synchronize()
                
                let save2 = UserDefaults.standard
                save2.set(true, forKey: "RestoredColorPack")
                save2.synchronize()
                
            }
            if (transaction.payment.productIdentifier == "com.TrevorWysong.MagnetHockeyGame.RemoveAds")
            {
                let save = UserDefaults.standard
                save.set(true, forKey: "Purchase")
                save.synchronize()
                
                let save2 = UserDefaults.standard
                save2.set(true, forKey: "RestoredRemoveAds")
                save2.synchronize()
            }
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState
{
    func status() -> String
    {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}
