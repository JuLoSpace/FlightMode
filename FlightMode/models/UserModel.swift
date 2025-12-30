//
//  userModel.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//


import Combine
import RevenueCat
import Foundation
import SwiftUI

enum SubscriptionType {
    case weekly
    case monthly
    case yearly
}

struct Subscription : Hashable {
    var type: SubscriptionType
    var price: String
    var amount: Double
}

class UserModel : ObservableObject {
    
    private var subscriptions: [SubscriptionType: Subscription] = [:]
    @Published private(set) var availableSubscriptions: [SubscriptionType: Bool] = [:]
    private var subscriptionPackages: [SubscriptionType : Package] = [:]
    
    private var discountSubscriptions: [SubscriptionType: Subscription] = [:]
    @Published private(set) var discountAvailableSubscriptions: [SubscriptionType: Bool] = [:]
    private var discountSubscriptionPackages: [SubscriptionType : Package] = [:]
    
    @Published private(set) var isPremium: Bool = false
    
    @AppStorage("promotional") var discount: Date?
    
    init() {
        initializatePurchases()
    }
    
    func initializatePurchases() {
        getOfferings()
        getCustomerInfo()
    }
    
    func getCustomerInfo() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let info = customerInfo {
                self.updateCustomerInfo(customerInfo: info)
            }
        }
    }
    
    func updateCustomerInfo(customerInfo: CustomerInfo) {
        if (customerInfo.activeSubscriptions.contains("weekly_sub") || customerInfo.activeSubscriptions.contains("yearly_sub") || customerInfo.activeSubscriptions.contains("monthly_sub")) {
            isPremium = true
        } else {
            isPremium = false
        }
    }
    
    func getOfferings() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.offering(identifier: "premium")?.availablePackages {
                packages.forEach { pack in
                    if pack.identifier == "$rc_lifetime" {
                        self.subscriptions[SubscriptionType.yearly] = Subscription(type: SubscriptionType.yearly, price: pack.storeProduct.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: pack.storeProduct.price)))
                        self.availableSubscriptions[SubscriptionType.yearly] = true
                        self.subscriptionPackages[SubscriptionType.yearly] = pack
                    }
                    if pack.identifier == "$rc_monthly" {
                        self.subscriptions[SubscriptionType.monthly] = Subscription(type: SubscriptionType.monthly, price: pack.storeProduct.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: pack.storeProduct.price)))
                        self.availableSubscriptions[SubscriptionType.monthly] = true
                        self.subscriptionPackages[SubscriptionType.monthly] = pack
                    }
                    if pack.identifier == "$rc_weekly" {
                        self.subscriptions[SubscriptionType.weekly] = Subscription(type: SubscriptionType.weekly, price: pack.storeProduct.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: pack.storeProduct.price)))
                        self.availableSubscriptions[SubscriptionType.weekly] = true
                        self.subscriptionPackages[SubscriptionType.weekly] = pack
                    }
                    
                    if pack.identifier == "yearly_sub_discount" {
                        self.discountSubscriptions[SubscriptionType.yearly] = Subscription(type: SubscriptionType.yearly, price: pack.storeProduct.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: pack.storeProduct.price)))
                        self.discountAvailableSubscriptions[SubscriptionType.yearly] = true
                        self.discountSubscriptionPackages[SubscriptionType.yearly] = pack
                    }
                    if pack.identifier == "monthly_sub_discount" {
                        self.discountSubscriptions[SubscriptionType.monthly] = Subscription(type: SubscriptionType.monthly, price: pack.storeProduct.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: pack.storeProduct.price)))
                        self.discountAvailableSubscriptions[SubscriptionType.monthly] = true
                        self.discountSubscriptionPackages[SubscriptionType.monthly] = pack
                    }
                    if pack.identifier == "weekly_sub_discount" {
                        self.discountSubscriptions[SubscriptionType.weekly] = Subscription(type: SubscriptionType.weekly, price: pack.storeProduct.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: pack.storeProduct.price)))
                        self.discountAvailableSubscriptions[SubscriptionType.weekly] = true
                        self.discountSubscriptionPackages[SubscriptionType.weekly] = pack
                    }
                }
            }
        }
    }
    
    func makePurchase(subscriptionType: SubscriptionType) {
        Purchases.shared.purchase(package: subscriptionPackages[subscriptionType]!) { (transaction, customerInfo, error, userCancelled) in
            if let info = customerInfo {
                self.updateCustomerInfo(customerInfo: info)
            }
        }
    }
    
    func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let info = customerInfo {
                self.updateCustomerInfo(customerInfo: info)
            }
        }
    }
    
    func getSubscription(subscriptionType: SubscriptionType) -> Subscription {
        return subscriptions[subscriptionType]!
    }
    
    func getDiscountSubscription(subscriptionType: SubscriptionType) -> Subscription {
        return discountSubscriptions[subscriptionType]!
    }
    
    func seeDiscount() {
        if (discount == nil) {
            discount = Date.now
        }
    }
    
    func promotionalExist() -> Int {
        return 3600 * 24 - Int(Date.now.timeIntervalSince(discount!))
    }
}
