//
//  MetricsService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 09.01.2026.
//

import Foundation
import Combine

class MetricsService {
    
    static let timeDelta: Double = 300.0 // in seconds
    static let airplaneAverageSpeed: Double = 230 // m/s
    
    static func getPosition(a: Airport, b: Airport, d: Double) -> (lat: Double, lon: Double) {
        let distance: Double = distance(a: a, b: b)
        let k: Double = d / distance
        let lat: Double = a.lat + (b.lat - a.lat) * k
        let lon: Double = a.lon + (b.lon - a.lon) * k
        return (lat, lon)
    }
    
    static func distance(a: Airport, b: Airport) -> Double {
        let earthRadiusKm: Double = 6371.0
        
        let dLat = (b.lat - a.lat) * .pi / 180
        let dLon = (b.lon - a.lon) * .pi / 180
        
        let c: Double = sin(dLat / 2) * sin(dLat / 2) + cos(a.lat * .pi / 180) * cos(b.lat * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        
        return 2 * 1000 * earthRadiusKm * atan2(sqrt(c), sqrt(1-c))
    }
    
    static func distance(lat: Double, lon: Double, b: Airport) -> Double {
        let earthRadiusKm: Double = 6371.0
        
        let dLat = (b.lat - lat) * .pi / 180
        let dLon = (b.lon - lon) * .pi / 180
        
        let c: Double = sin(dLat / 2) * sin(dLat / 2) + cos(lat * .pi / 180) * cos(b.lat * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        
        return 2 * 1000 * earthRadiusKm * atan2(sqrt(c), sqrt(1-c))
    }
    
    static func heading(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let radiansHeading = atan2(y, x)
        var degreesHeading = radiansHeading * 180 / .pi
        
        if degreesHeading < 0 {
            degreesHeading += 360.0
        }
        
        return degreesHeading
    }
}
