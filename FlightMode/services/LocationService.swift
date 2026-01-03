//
//  LocationService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import CoreLocation
import Foundation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    
    var locationCallback: (() -> ())?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        var move: Bool = false
        if (self.location == nil) {
            move = true
        }
        self.location = location.coordinate
        if move {
            if let callback = locationCallback {
                callback()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
}
