//
//  flightEntity.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 09.01.2026.
//

import Foundation
import Combine


enum FlightType {
    case success
    case process
    case cancelled
    case pause
    case planned
}

class Position: Equatable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func == (_ lhs: Position, _ rhs: Position) -> Bool {
        return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

class FlightProcess: ObservableObject {
    
    var flightType: FlightType
    @Published var position: Position?
    @Published var flightTime: TimeInterval = TimeInterval.zero
    
    init(flightType: FlightType) {
        self.flightType = flightType
    }
    
    init(flightType: FlightType, position: Position) {
        self.flightType = flightType
        self.position = position
    }
}

class Flight: ObservableObject {
    
    var flightProcess: FlightProcess
    let airportDeparture: Airport
    let airportDestination: Airport
    var timeDeparture: Date?
    var timeDestination: Date?
    var depart: Bool = false
    
    var stops: [TimeInterval] = []
    
    @Published var remainingTime: Double = 0.0
    @Published var remainingDistance: Double = 0.0
    @Published var currentSpeed: Double = 0.0
    
    private var timer: Timer?
    
    init(flightProcess: FlightProcess, airportDeparture: Airport, airportDestination: Airport) {
        self.flightProcess = flightProcess
        self.airportDeparture = airportDeparture
        self.airportDestination = airportDestination
    }
    
    init(flightProcess: FlightProcess, airportDeparture: Airport, airportDestination: Airport, timeDeparture: Date, timeDestination: Date) {
        self.flightProcess = flightProcess
        self.airportDeparture = airportDeparture
        self.airportDestination = airportDestination
        self.timeDeparture = timeDeparture
        self.timeDestination = timeDestination
    }
    
    var __remainingDistance: Double {
        guard let position = self.flightProcess.position else { return 0.0 }
        return MetricsService.distance(lat: position.latitude, lon: position.longitude, b: airportDestination)
    }
    
    var __remainingTime: Double {
        let time: Double = __remainingDistance / MetricsService.airplaneAverageSpeed
        return time
    }
    
    var __currentSpeed: Double {
        return MetricsService.airplaneAverageSpeed
    }
    
    func startFlight() {
        timeDeparture = Date.now
        self.flightProcess.position = Position(latitude: airportDeparture.lat, longitude: airportDeparture.lon)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.01), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let timeDeparture = self.timeDeparture {
                self.flightProcess.flightTime = Date.now.timeIntervalSince(timeDeparture)
                let pos = MetricsService.getPosition(a: self.airportDeparture, b: self.airportDestination, d: self.flightProcess.flightTime * MetricsService.airplaneAverageSpeed)
                self.flightProcess.position = Position(
                    latitude: pos.lat,
                    longitude: pos.lon)
                DispatchQueue.main.async {
                    self.remainingDistance = self.__remainingDistance
                    self.remainingTime = self.__remainingTime
                    self.currentSpeed = self.__currentSpeed
                }
                
                if self.remainingDistance < 0 {
                    self.endFlight()
                }
            } else {
                return
            }
        }
    }
    
    func endFlight() {
        timer?.invalidate()
        timer = nil
        timeDestination = Date.now
    }
    
    func stop() {
        
    }
    
    func run() {
        
    }
}
