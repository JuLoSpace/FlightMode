//
//  userModel.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//


import Combine
import RevenueCat
import Foundation

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
    private var promotionalSubscriptions: [SubscriptionType: Subscription] = [:]
    @Published private(set) var availableSubscriptions: [SubscriptionType: Bool] = [:]
    @Published private(set) var availablePromotionalSubscriptions: [SubscriptionType: Bool] = [:]
    private var subscriptionPackages: [SubscriptionType : Package] = [:]
    @Published private(set) var isPremium: Bool = false
    
    
    init() {
        initializatePurchases()
    }
    
    func initializatePurchases() {
        getCustomerInfo()
        getOfferings()
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
                    if let discount = pack.storeProduct.discounts.first {
                        Purchases.shared.getPromotionalOffer(forProductDiscount: discount, product: pack.storeProduct) { (promoOffer, error) in
                            if let offer = promoOffer {
                                if pack.identifier == "$rc_lifetime" {
                                    self.promotionalSubscriptions[SubscriptionType.yearly] = Subscription(type: SubscriptionType.yearly, price: offer.discount.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: offer.discount.price)))
                                    self.availablePromotionalSubscriptions[SubscriptionType.yearly] = true
                                }
                                if pack.identifier == "$rc_monthly" {
                                    self.promotionalSubscriptions[SubscriptionType.monthly] = Subscription(type: SubscriptionType.monthly, price: offer.discount.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: offer.discount.price)))
                                    self.availablePromotionalSubscriptions[SubscriptionType.monthly] = true
                                }
                                if pack.identifier == "$rc_weekly" {
                                    self.promotionalSubscriptions[SubscriptionType.weekly] = Subscription(type: SubscriptionType.weekly, price: offer.discount.localizedPriceString, amount: Double(truncating: NSDecimalNumber(decimal: offer.discount.price)))
                                    self.availablePromotionalSubscriptions[SubscriptionType.weekly] = true
                                }
                            }
                        }
                    }
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
    
    func getPromotionalSubscription(subscriptionType: SubscriptionType) -> Subscription {
        return promotionalSubscriptions[subscriptionType]!
    }
}
