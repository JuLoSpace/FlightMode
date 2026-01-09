//
//  MapService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//

import Foundation
import Combine


class MapService: ObservableObject {
    
    static var mapMoveCallback: ((_ lat: Double, _ lon: Double, _ delta: Double, _ duration: Double) -> ())?
    
}
