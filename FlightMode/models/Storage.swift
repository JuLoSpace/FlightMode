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
    
    static func readName() -> String {
        return defaults.object(forKey: "username") as? String ?? "cadet"
    }
    
    static func saveName(name: String) {
        defaults.set(name, forKey: "username")
    }
    
    static func saveFlight(flight: Flight) {
        var flights = readFlightDTOs()
        flights.append(flight.toDTO())
        saveFlightDTOs(flights: flights)
    }
    
    static func readFlights(airports: [Airport]) -> [Flight] {
        readFlightDTOs().compactMap {
            Flight(dto: $0, airports: airports)
        }
    }
    
    private static func saveFlightDTOs(flights: [FlightDTO]) {
        do {
            let data = try JSONEncoder().encode(flights)
            defaults.set(data, forKey: "flights")
        } catch {
            print(error)
        }
    }
    
    private static func readFlightDTOs() -> [FlightDTO] {
        guard let data = defaults.data(forKey: "flights") else {
            return []
        }
        do {
            return try JSONDecoder().decode([FlightDTO].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
    
    static func cleanFlightDTOs() {
        defaults.removeObject(forKey: "flights")
    }
    
    static func saveSettings(settings: SettingsDTO) {
        do {
            let data = try JSONEncoder().encode(settings)
            defaults.set(data, forKey: "settings")
        } catch {
            print(error)
        }
    }
    
    static func readSettings() -> SettingsService {
        guard let data = defaults.data(forKey: "settings") else {
            return SettingsService()
        }
        do {
            let dto = try JSONDecoder().decode(SettingsDTO.self, from: data)
            return SettingsService(dto: dto)
        } catch {
            print(error)
            return SettingsService()
        }
    }
}
