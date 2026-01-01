//
//  ContentView.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 16.12.2025.
//

import SwiftUI
import MapKit

struct OnboardingScreenFirst: View {
    
    @EnvironmentObject var router: Router
    
    @State private var rotateEarth: Bool = false
    @State private var step: Double = 1
    
    @State var cameraPosition: MapCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), distance: 20000000.0))
    
    @State var offset: Double = 0.0
    
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, interactionModes: [])
                .mapStyle(.hybrid(elevation: .realistic))
                .mapControlVisibility(.hidden)
                .padding(.zero)
                .ignoresSafeArea(edges: .all)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("WELCOME")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                        Image("ticket")

                    }
                    HStack {
                        Text("TO")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("FLIGHTMODE")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFAE17"))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                Text("Your journey to deep focus begins here.")
                    .padding()
                    .font(.custom("Montserrat", size: 18))
                    .foregroundStyle(.white)
                    .fontWeight(.regular)
                Spacer()
                if #available(iOS 26, *) {
                    Button(action: {
                        router.navigate(to: Route.onboarding(Route.OnboardingScreen.second))
                    }, label: {
                        Text("👋 Hey")
                            .font(.custom("Montserrat", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                    })
                    .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                    .padding(.horizontal, 20)
                } else {
                    Button(action: {
                        router.navigate(to: Route.onboarding(Route.OnboardingScreen.second))
                    }, label: {
                        Text("👋 Hey")
                            .font(.custom("Montserrat", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                    })
                    .buttonStyle(CustomButtonStyle(color: Color(hex: "FFAE17").opacity(0.7)))
                    .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
        .onAppear {
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                cameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: offset, longitude: offset), distance: 20000000.0))
                offset += 0.01
                if (offset > 85) {
                    offset = 0
                }
            }
        }
    }
}

#Preview {
    OnboardingScreenFirst()
}
