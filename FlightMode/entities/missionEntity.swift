//
//  missionEntity.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//


enum Mission: CaseIterable {
    case code
    case read
    case write
    case work
    case exercise
    case fly
    case podcast
    case learn
    case cook
    case research
    case explore
    case study
    case meditate
    case design
    
    var emoji: String {
        switch self {
        case .code:
            "🧑‍💻"
        case .read:
            "📙"
        case .write:
            "✒️"
        case .exercise:
            "🏃‍♂️"
        case .fly:
            "🛩️"
        case .cook:
            "🥣"
        case .meditate:
            "🧘"
        case .design:
            "🎨"
        case .research:
            "🔍"
        default:
            ""
        }
    }
    
    var name: String {
        switch self {
        case .code:
            "Code"
        case .read:
            "Read"
        case .write:
            "Write"
        case .work:
            "Work"
        case .exercise:
            "Exercise"
        case .fly:
            "Fly"
        case .podcast:
            "Podcast"
        case .learn:
            "Learn"
        case .cook:
            "Cook"
        case .research:
            "Research"
        case .explore:
            "Explore"
        case .study:
            "Study"
        case .meditate:
            "Meditate"
        case .design:
            "Design"
        }
    }
}
