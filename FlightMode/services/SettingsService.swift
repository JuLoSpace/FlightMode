//
//  SettingsService.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 11.01.2026.
//

import Combine
import Foundation

enum SexType: Codable {
    case man
    case woman
}


class SettingsService: ObservableObject {
    
    // User information
    @Published var name: String?
    @Published var sexType: SexType?
    
    // Map settings
    
    // Notifications
    @Published var dailyReminders: Bool = false
    @Published var achievmentAlerts: Bool = false
    @Published var streakWarnings: Bool = false
    @Published var challengeUpdates: Bool = false
    
    // Sound & Haptics
    @Published var flightSound: Bool?
    @Published var volume: Bool?
    @Published var hapticFeedback: Bool?
    
    init(name: String? = nil, sexType: SexType? = nil, dailyReminders: Bool, achievmentAlerts: Bool, streakWarnings: Bool, challengeUpdates: Bool, flightSound: Bool? = nil, volume: Bool? = nil, hapticFeedback: Bool? = nil) {
        self.name = name
        self.sexType = sexType
        self.dailyReminders = dailyReminders
        self.achievmentAlerts = achievmentAlerts
        self.streakWarnings = streakWarnings
        self.challengeUpdates = challengeUpdates
        self.flightSound = flightSound
        self.volume = volume
        self.hapticFeedback = hapticFeedback
        setupAutosave()
    }
    
    init(name: String? = nil, sexType: SexType? = nil, flightSound: Bool? = nil, volume: Bool? = nil, hapticFeedback: Bool? = nil) {
        self.name = name
        self.sexType = sexType
        self.dailyReminders = dailyReminders
        self.achievmentAlerts = achievmentAlerts
        self.streakWarnings = streakWarnings
        self.challengeUpdates = challengeUpdates
        self.flightSound = flightSound
        self.volume = volume
        self.hapticFeedback = hapticFeedback
        setupAutosave()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupAutosave() {
        objectWillChange
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                Storage.saveSettings(settings: self.toDTO())
            }
            .store(in: &cancellables)
    }
}


struct SettingsDTO: Codable {
    // User information
    let name: String?
    let sexType: SexType?
    
    // Map settings
    
    // Notifications
    let dailyReminders: Bool
    let achievmentAlerts: Bool
    let streakWarnings: Bool
    let challengeUpdates: Bool
    
    // Sound & Haptics
    let flightSound: Bool?
    let volume: Bool?
    let hapticFeedback: Bool?
}

extension SettingsService {
    func toDTO() -> SettingsDTO {
        return SettingsDTO(name: name, sexType: sexType, dailyReminders: dailyReminders, achievmentAlerts: achievmentAlerts, streakWarnings: streakWarnings, challengeUpdates: challengeUpdates, flightSound: flightSound, volume: volume, hapticFeedback: hapticFeedback)
    }
}

extension SettingsService {
    convenience init(dto: SettingsDTO) {
        self.init(
            name: dto.name, sexType: dto.sexType, dailyReminders: dto.dailyReminders, achievmentAlerts: dto.achievmentAlerts, streakWarnings: dto.streakWarnings, challengeUpdates: dto.challengeUpdates, flightSound: dto.flightSound, volume: dto.volume, hapticFeedback: dto.hapticFeedback
        )
    }
}
