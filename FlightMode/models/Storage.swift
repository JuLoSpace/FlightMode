//
//  AppStorage.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 04.01.2026.
//

import Foundation

class Storage {
    
    static let defaults = UserDefaults.standard
    static let cloudStorage = CloudStorage()
    
    static func saveFavoriteMissions(missions: [Mission]) {
        if let encoded = try? JSONEncoder().encode(missions) {
            defaults.set(encoded, forKey: "favoriteMissions")
        }
    }
    
    static func readFavoriteMissions() -> [Mission] {
        if let savedFavoriteMissions = UserDefaults.standard.object(forKey: "favoriteMissions") as? Data, let loadedFavoriteMissions = try? JSONDecoder().decode([Mission].self, from: savedFavoriteMissions) {
            return loadedFavoriteMissions
        }
        return []
    }
    
    static func saveNotificationTime(time: TimeInterval) {
        defaults.set(time, forKey: "notificationTime")
    }
    
    static func readNotificationTime() -> TimeInterval {
        return defaults.double(forKey: "notificationTime")
    }
    
    static func saveDiscountDate(date: Date) {
        defaults.set(date, forKey: "discountDate")
    }
    
    static func readDiscountDate() -> Date {
        return defaults.object(forKey: "discountDate") as? Date ?? Date()
    }
    
    static func readViewOnboarding() -> Bool {
        return defaults.object(forKey: "viewOnboarding") as? Bool ?? false
    }
    
    static func saveViewOnboarding(viewed: Bool) {
        defaults.set(viewed, forKey: "viewOnboarding")
    }
}
