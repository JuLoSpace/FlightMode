//
//  ContentView.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 16.12.2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



struct OnboardingScreenFirst: View {
    
    @EnvironmentObject var router: Router
    
    @State private var rotateEarth: Bool = false
    @State private var step: Double = 1
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    Text("WELCOME")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                    Image("ticket")

                }
                HStack {
                    Text("TO")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("FLIGHTMODE")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Image("earth")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .rotationEffect(Angle(degrees: rotateEarth ? 360 : 0))
                .animation(.linear(duration: 30).repeatForever(autoreverses: false), value: rotateEarth)
                .onAppear() {
                    rotateEarth = true
                }
            Text("Your journey to deep focus begins here.")
                .padding()
                .font(.custom("Montserrat", size: 18))
                .foregroundStyle(.white)
            Spacer()
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
            .glassEffect(.clear.tint(Color(hex: "FFAE17")).interactive())
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
        .onAppear {
            withAnimation(.default) {
                step = 0
            }
        }
    }
}

#Preview {
    OnboardingScreenFirst()
}
