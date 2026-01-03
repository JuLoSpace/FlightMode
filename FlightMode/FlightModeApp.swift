//
//  FlightModeTestApp.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 16.12.2025.
//

import SwiftUI
import RevenueCat

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

@main
struct FlightModeApp: App {
    
    init() {
        Purchases.configure(withAPIKey: "appl_mBgKusTNpFopOKLkFIwVbwBSIvt")
    }
    
    @StateObject private var router = Router()
    @StateObject private var user = UserModel()
    @StateObject private var airportsService = AirportsService()
    @StateObject private var locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeScreen()
                    .navigationDestination(for: Route.self) { route in
                        Group {
                            switch route {
                            case .onboarding(let screen):
                                switch screen {
                                case .first:
                                    OnboardingScreenFirst()
                                case .second:
                                    OnboardingScreenSecond()
                                case .third:
                                    OnboardingScreenThird()
                                case .fourth:
                                    OnboardingScreenFourth()
                                case .fifth:
                                    OnboardingScreenFifth()
                                case .sixth:
                                    OnboardingScreenSixth()
                                case .seventh:
                                    OnboardingScreenSeventh()
                                case .eighth:
                                    OnboardingScreenEighth()
                                case .nineth:
                                    OnboardingScreenNineth()
                                }
                            case .paywall:
                                PaywallScreen()
                            case .promotionalPaywall:
                                PromotionalPaywallScreen()
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .interactiveDismissDisabled(false)
                    }
                    .navigationBarHidden(true)
//                    .accessibilityHidden(true)
            }
            .environmentObject(router)
            .environmentObject(user)
            .environmentObject(airportsService)
            .environmentObject(locationService)
        }
    }
}
