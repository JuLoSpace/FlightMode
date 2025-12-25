//
//  career.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//

enum Career : CaseIterable {
    case cadet
    case junior
    case senior
    case captain
    case ace
    case legend
    
    var index: Int {
        Career.allCases.firstIndex(of: self) ?? 0
    }
    
    var name: String {
        switch self {
        case .cadet:
            "Cadet"
        case .junior:
            "Junior Pilot"
        case .senior:
            "Senior Pilot"
        case .captain:
            "Captain"
        case .ace:
            "Ace Pilot"
        case .legend:
            "Legend"
        }
    }
    
    var flights: Int {
        switch self {
        case .cadet:
            0
        case .junior:
            5
        case .senior:
            15
        case .captain:
            50
        case .ace:
            100
        case .legend:
            250
        }
    }
    
    var imageName: String {
        switch self {
        case .cadet:
            "cadet"
        case .junior:
            "junior"
        case .senior:
            "senior"
        case .captain:
            "captain"
        case .ace:
            "ace"
        case .legend:
            "legend"
        }
    }
}
