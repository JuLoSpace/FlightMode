//
//  AirportsService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import Foundation
import Combine

struct Airport: Codable {
    let icao: String
    let iata: String?
    let name: String?
    let city: String?
    let country: String?
    let elevation: Int?
    let lat: Double
    let lon: Double
    let tz: String?
}

class AirportsService: ObservableObject {
    
    @Published private(set) var airports: [Airport] = []
    @Published private(set) var cityAirpots: [String: Airport] = [:]
    
    init() {
        load()
    }
    
    func load() {
        guard let url = Bundle.main.url(forResource: "airports", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let dict = try decoder.decode([String: Airport].self, from: data)
            airports = Array(dict.values)
        } catch {
            
        }
    }
    
    func search(_ query: String) -> [Airport] {
        let lowercasedQuery = query.lowercased()
        
        return Array((airports.filter { airport in
            airport.icao.lowercased().contains(lowercasedQuery) ||
            airport.name?.lowercased().contains(lowercasedQuery) ?? false
        }).prefix(100))
    }
    
    func distance(a: Airport, b: Airport) -> Double {
        let earthRadiusKm: Double = 6371.0
        
        let dLat = (b.lat - a.lat) * .pi / 180
        let dLon = (b.lon - a.lon) * .pi / 180
        
        let c: Double = sin(dLat / 2) * sin(dLat / 2) + cos(a.lat * .pi / 180) * cos(b.lat * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        
        return 2 * earthRadiusKm * atan2(sqrt(c), sqrt(1-c))
    }
    
    func distance(lat: Double, lon: Double, b: Airport) -> Double {
        let earthRadiusKm: Double = 6371.0
        
        let dLat = (b.lat - lat) * .pi / 180
        let dLon = (b.lon - lon) * .pi / 180
        
        let c: Double = sin(dLat / 2) * sin(dLat / 2) + cos(lat * .pi / 180) * cos(b.lat * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        
        return 2 * earthRadiusKm * atan2(sqrt(c), sqrt(1-c))
    }
}
