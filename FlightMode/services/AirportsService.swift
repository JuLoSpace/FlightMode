//
//  AirportsService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import Foundation
import Combine

struct Airport: Codable, Equatable {
    let icao: String
    let iata: String?
    let name: String?
    let city: String?
    let country: String?
    let elevation: Int?
    let lat: Double
    let lon: Double
    let tz: String?
    
    static func == (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.lat == rhs.lat &&
        lhs.lon == rhs.lon &&
        lhs.icao == rhs.icao
    }
}

class AirportPoint: Hashable {
    let airport: Airport
    var nearest: Bool
    let time: Double
    
    init(airport: Airport, nearest: Bool, time: Double) {
        self.airport = airport
        self.nearest = nearest
        self.time = time
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(airport.name)
    }
    
    static func == (lhs: AirportPoint, rhs: AirportPoint) -> Bool {
        return lhs.airport.lat == rhs.airport.lat &&
        lhs.airport.lon == rhs.airport.lon &&
        lhs.airport.name == rhs.airport.name
    }
}

class Flight {
    
    let airportDeparture: Airport
    let airportDestination: Airport
    let timeDeparture: Date
    var timeDestination: Date
    var currentPosition: (lat: Double, lon: Double)?
    var depart: Bool = false
    
    var timeToEnd: Double {
        return 1 // TODO
    }
    
    init(airportDeparture: Airport, airportDestination: Airport, timeDeparture: Date, timeDestination: Date) {
        self.airportDeparture = airportDeparture
        self.airportDestination = airportDestination
        self.timeDeparture = timeDeparture
        self.timeDestination = timeDestination
        self.currentPosition = (airportDeparture.lat, airportDeparture.lon)
    }
}

class AirportsService: ObservableObject {
    
    @Published private(set) var airports: [Airport] = []
    @Published private(set) var cityAirports: [String: [Airport]] = [:]
    
    @Published private(set) var showableAirports: [AirportPoint] = []
    
    @Published var departureAirport: Airport?
    @Published var destinationAirport: Airport?
    @Published private(set) var selectedTime: Double?
    
    let timeDelta: Double = 300.0 // in seconds
    let airplaneAverageSpeed: Double = 230 // m/s
    
    var mapMoveCallback: ((_ lat: Double, _ lon: Double, _ delta: Double) -> ())?
    
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
            airports.removeAll(where: { airport in
                airport.iata == nil || airport.name == nil || airport.iata == "" || airport.icao == ""
            })
            getCityAirports()
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
        
        return 2 * 1000 * earthRadiusKm * atan2(sqrt(c), sqrt(1-c))
    }
    
    func distance(lat: Double, lon: Double, b: Airport) -> Double {
        let earthRadiusKm: Double = 6371.0
        
        let dLat = (b.lat - lat) * .pi / 180
        let dLon = (b.lon - lon) * .pi / 180
        
        let c: Double = sin(dLat / 2) * sin(dLat / 2) + cos(lat * .pi / 180) * cos(b.lat * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        
        return 2 * 1000 * earthRadiusKm * atan2(sqrt(c), sqrt(1-c))
    }
    
    func findNearestAirport(lat: Double, lon: Double) -> Airport? {
        
        var a: Airport?
        var dist: Double = .infinity
        
        for airport in airports {
            let d: Double = distance(lat: lat, lon: lon, b: airport)
            if (d < dist) {
                dist = d
                a = airport
            }
        }
        
        return a
    }
    
    func getCityAirports() {
        var cityAirports: [String: [Airport]] = [:]
        for airport in airports {
            if let cityName = airport.city {
                cityAirports[cityName]?.append(airport)
            }
        }
        self.cityAirports = cityAirports
    }
    
    func getShowableAirports(lat: Double, lon: Double, time: Double) {
        Task {
            if let a = findNearestAirport(lat: lat, lon: lon) {
                departureAirport = a
                selectedTime = time
                var airportPoints: [AirportPoint] = []
                for airport in airports {
                    let d: Double = distance(a: a, b: airport)
                    let time: Double = d / airplaneAverageSpeed // time to fly in seconds
                    let point: AirportPoint = AirportPoint(airport: airport, nearest: false, time: time)
                    airportPoints.append(point)
                }
                airportPoints.sort(by: { a, b in
                    return abs(a.time - time) < abs(b.time - time)
                })
                airportPoints.removeAll(where: { point in
                    abs(point.time - time) > timeDelta
                })
                airportPoints.sort(by: { a, b in
                    return a.time < b.time
                })
                if let bestAirport = airportPoints.first {
                    destinationAirport = bestAirport.airport
                    bestAirport.nearest = true
                }
                self.showableAirports = airportPoints
                if let mapCallback = mapMoveCallback {
                    mapCallback(a.lat, a.lon, 1.5 * 360.0 * time * airplaneAverageSpeed / (6371000.0 * .pi))
                }
            }
        }
    }
    
    func getShowableAirports(airport: Airport, time: Double) {
        departureAirport = airport
    }
    
    func selectDestinationAirport(_ airport: Airport) {
        self.destinationAirport = airport
    }
}
