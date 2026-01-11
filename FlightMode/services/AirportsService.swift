//
//  AirportsService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import Foundation
import Combine

struct Airport: Codable, Equatable, Hashable {
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

class AirportsService: ObservableObject {
    
    @Published private(set) var airports: [Airport] = []
    @Published private(set) var cityAirports: [String: [Airport]] = [:]
    
    @Published private(set) var showableAirports: [AirportPoint] = []
    
    @Published var departureAirport: Airport?
    @Published var destinationAirport: Airport?
    @Published private(set) var selectedTime: Double?
    
    @Published private(set) var currentFlight: Flight?
    
    @Published var historyFlights: [Flight]?
    
    var onFlightEndCallback: (() -> ())?
    
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
            loadHistoryFlights()
        } catch {
            
        }
    }
    
    func loadHistoryFlights() {
        historyFlights = Storage.readFlights(airports: airports)
    }
    
    func search(_ query: String) -> [Airport] {
        let lowercasedQuery = query.lowercased()
        
        return Array((airports.filter { airport in
            airport.icao.lowercased().contains(lowercasedQuery) ||
            airport.name?.lowercased().contains(lowercasedQuery) ?? false
        }).prefix(100))
    }
    
    func findNearestAirport(lat: Double, lon: Double) -> Airport? {
        
        var a: Airport?
        var dist: Double = .infinity
        
        for airport in airports {
            let d: Double = MetricsService.distance(lat: lat, lon: lon, b: airport)
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
    
    func searchAirportsByQuery(_ query: String) -> [String: [Airport]] {
        
        let q = query.lowercased()
        
        let queryAirports = airports.filter { airport in
            (airport.name?.lowercased().hasPrefix(q) ?? false) || airport.icao.lowercased().hasPrefix(q) || (airport.iata?.lowercased().hasPrefix(q) ?? false) || (airport.city?.lowercased().hasPrefix(q) ?? false)
        }
        
        var out: [String: [Airport]] = [:]
        
        queryAirports.forEach { airport in
            if let city = airport.city {
                if out[city] == nil {
                    out[city] = []
                }
                out[city]?.append(airport)
            }
        }
        
        return out
    }
    
    func setDepartureAirport(_ departure: Airport) {
        departureAirport = departure
        if let mapMoveCallback = MapService.mapMoveCallback {
            mapMoveCallback(departure.lat, departure.lon, 1.0, 2.0, 0)
        }
    }
    
    func getShowableAirports(lat: Double, lon: Double, time: Double) {
        Task {
            if let a = findNearestAirport(lat: lat, lon: lon) {
                departureAirport = a
                selectedTime = time
                var airportPoints: [AirportPoint] = []
                for airport in airports {
                    let d: Double = MetricsService.distance(a: a, b: airport)
                    let time: Double = d / MetricsService.airplaneAverageSpeed // time to fly in seconds
                    let point: AirportPoint = AirportPoint(airport: airport, nearest: false, time: time)
                    airportPoints.append(point)
                }
                airportPoints.sort(by: { a, b in
                    return abs(a.time - time) < abs(b.time - time)
                })
                airportPoints.removeAll(where: { point in
                    abs(point.time - time) > MetricsService.timeDelta
                })
                airportPoints.sort(by: { a, b in
                    return a.time < b.time
                })
                if let bestAirport = airportPoints.first {
                    destinationAirport = bestAirport.airport
                    bestAirport.nearest = true
                }
                self.showableAirports = airportPoints
                if let mapCallback = MapService.mapMoveCallback {
                    mapCallback(a.lat, a.lon, 1.5 * 360.0 * time * MetricsService.airplaneAverageSpeed / (6371000.0 * .pi), 2.0, 0)
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
    
    func cancel() {
        
        departureAirport = nil
        destinationAirport = nil
        
        showableAirports = []
        selectedTime = nil
        
        currentFlight = nil
    }
    
    func flight() {
        
        guard let departureAirport = departureAirport else { return }
        guard let destinationAirport = destinationAirport else { return }
        
        showableAirports = []
        selectedTime = nil
        
        let middleLat: Double = (departureAirport.lat + destinationAirport.lat) / 2.0
        let middleLon: Double = (departureAirport.lon + destinationAirport.lon) / 2.0
        
        let latDelta = abs(departureAirport.lat - destinationAirport.lat)
        let lonDelta = abs(departureAirport.lon - destinationAirport.lon)
        
        let delta = max(latDelta, lonDelta) * 1.5
        
        if let mapMoveCallback = MapService.mapMoveCallback {
            mapMoveCallback(middleLat, middleLon, delta, 2.0, 0)
        }
        
        let newFlight = Flight(
            flightProcess: FlightProcess(flightType: .planned),
            airportDeparture: departureAirport,
            airportDestination: destinationAirport)
        
        currentFlight = newFlight
        newFlight.startFlight()
        
        newFlight.onFlightEndCallback = endFlight
        
        if let move = MapService.mapMoveToAirplanePosition {
            move()
        }
    }
    
    func endFlight() {
        if let currentFlight = currentFlight {
            Storage.saveFlight(flight: currentFlight)
            historyFlights?.append(currentFlight)
        }
        if let onFlightEndCallback = onFlightEndCallback {
            onFlightEndCallback()
        }
//        currentFlight = nil
    }
}
