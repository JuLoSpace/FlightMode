//
//  router.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 17.12.2025.
//

import SwiftUI
import Combine

enum Route : Hashable {
    
    case onboarding(OnboardingScreen)
    case paywall
    
    enum OnboardingScreen {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
        case seventh
        case eighth
        case nineth
    }
}

class Router : ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
