//
//  flightEntity.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 09.01.2026.
//

import Foundation
import Combine
import CoreLocation

enum FlightType: String, Codable {
    case success
    case process
    case cancelled
    case pause
    case planned
}

class Position: ObservableObject, Equatable {
    
    @Published var latitude: Double
    @Published var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func == (_ lhs: Position, _ rhs: Position) -> Bool {
        return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

struct PositionDTO: Codable {
    let latitude: Double
    let longitude: Double
}

class FlightProcess: ObservableObject {
    
    @Published var flightType: FlightType
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

struct FlightProcessDTO: Codable {
    let flightType: FlightType
    let position: PositionDTO?
    let flightTime: TimeInterval
}

class Flight: ObservableObject, Hashable, Equatable {
    
    var id: UUID?
    
    @Published var flightProcess: FlightProcess
    let airportDeparture: Airport
    let airportDestination: Airport
    var timeDeparture: Date?
    var timeDestination: Date?
    var depart: Bool = false
    
    var stops: [Date] = []
    
    var onFlightEndCallback: (() -> ())?
    
    @Published var remainingTime: Double = 0.0
    @Published var remainingDistance: Double = 0.0
    @Published var currentSpeed: Double = 0.0
    
    private var timer: Timer?
    
    init(flightProcess: FlightProcess, airportDeparture: Airport, airportDestination: Airport) {
        self.flightProcess = flightProcess
        self.airportDeparture = airportDeparture
        self.airportDestination = airportDestination
        self.id = UUID()
    }
    
    init(flightProcess: FlightProcess, airportDeparture: Airport, airportDestination: Airport, timeDeparture: Date, timeDestination: Date, id: UUID) {
        self.flightProcess = flightProcess
        self.airportDeparture = airportDeparture
        self.airportDestination = airportDestination
        self.timeDeparture = timeDeparture
        self.timeDestination = timeDestination
        self.id = id
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
    
    func startFlight(isStopped: Bool = false) {
        if !isStopped {
            timeDeparture = Date.now
            self.flightProcess.position = Position(latitude: airportDeparture.lat, longitude: airportDeparture.lon)
        }
        flightProcess.flightType = .process
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.01), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let timeDeparture = self.timeDeparture {
                self.flightProcess.flightTime = Date.now.timeIntervalSince(timeDeparture)
                let pos = MetricsService.getPosition(a: self.airportDeparture, b: self.airportDestination, d: self.flightProcess.flightTime * MetricsService.airplaneAverageSpeed)
                self.flightProcess.position = Position(
                    latitude: pos.lat,
                    longitude: pos.lon
                )
                DispatchQueue.main.async {
                    self.remainingDistance = self.__remainingDistance
                    self.remainingTime = self.__remainingTime
                    self.currentSpeed = self.__currentSpeed
                }
                if let pos = self.flightProcess.position {
                    if MetricsService.distance(lat: pos.latitude, lon: pos.longitude, b: self.airportDeparture) > MetricsService.distance(a: self.airportDeparture, b: self.airportDestination) {
                        self.flightProcess.flightType = .success // TODO
                        self.endFlight()
                        if let onFlightEndCallback = onFlightEndCallback {
                            onFlightEndCallback()
                        }
                    }
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
    
    func pause() {
        timer?.invalidate()
        timer = nil
        flightProcess.flightType = .pause
        stops.append(Date.now)
    }
    
    func run() {
        startFlight(isStopped: true)
    }
    
    static func ==(_ lhs: Flight, _ rhs: Flight) -> Bool {
        return lhs.airportDeparture == rhs.airportDeparture &&
        lhs.airportDestination == rhs.airportDestination &&
        lhs.timeDeparture == rhs.timeDeparture
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timeDeparture)
    }
}


struct FlightDTO: Codable {
    let flightProcess: FlightProcessDTO
    let airportDepartureICAO: String
    let airportDestinationICAO: String
    let timeDeparture: Date?
    let timeDestination: Date?
    let remainingTime: Double
    let remainingDistance: Double
    let currentSpeed: Double
    let id: UUID
}

extension Flight {
    func toDTO() -> FlightDTO {
        FlightDTO(
            flightProcess: FlightProcessDTO(flightType: flightProcess.flightType, position: flightProcess.position.map {
                PositionDTO(latitude: $0.latitude, longitude: $0.longitude)
            }, flightTime: flightProcess.flightTime), airportDepartureICAO: airportDeparture.icao, airportDestinationICAO: airportDestination.icao, timeDeparture: timeDeparture, timeDestination: timeDestination, remainingTime: remainingTime, remainingDistance: remainingDistance, currentSpeed: currentSpeed, id: UUID())
    }
}

extension Flight {
    convenience init?(dto: FlightDTO, airports: [Airport]) {
        guard
            let departure = airports.first(where: { $0.icao == dto.airportDepartureICAO }),
            let destination = airports.first(where: { $0.icao == dto.airportDestinationICAO })
        else {
            return nil
        }
        
        let process = FlightProcess(flightType: dto.flightProcess.flightType)
        
        if let pos = dto.flightProcess.position {
            process.position = Position(latitude: pos.latitude, longitude: pos.longitude)
        }
        
        process.flightTime = dto.flightProcess.flightTime
        
        let id = dto.id
        
        self.init(flightProcess: process, airportDeparture: departure, airportDestination: destination, timeDeparture: dto.timeDeparture ?? Date(), timeDestination: dto.timeDestination ?? Date(), id: id)
        
        self.remainingTime = dto.remainingTime
        self.remainingDistance = dto.remainingDistance
        self.currentSpeed = dto.currentSpeed
    }
}
