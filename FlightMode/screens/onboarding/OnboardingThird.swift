//
//  onboarding_3.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 16.12.2025.
//

import SwiftUI

// TODO: make all variables more flexible
struct CardView : View, Animatable {
    
    var description: String
    var image: String
    var width: Double
    var height: Double
    var offsetX: Double
    var offsetY: Double
    var step: Double
    
    var animatableData: Double {
        get {
            step
        }
        set {
            step = newValue
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(description)
                    .font(.custom("Montserrat", size: 16))
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding()
                Spacer()
            }
            Image(image)
                .aspectRatio(contentMode: .fill)
                .offset(CGSize(width: width * offsetX, height: height * offsetY + (step == 0 ? 0 : height * sin(step))))
                .clipped()
                .frame(width: width, height: height)
        }
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 16))
        .frame(width: width, height: height)
        .clipped()
    }
}


struct OnboardingScreenThird : View {
    
    @EnvironmentObject var router: Router
    
    @State private var step: Double = 1
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        router.navigateBack()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .padding(.all, 6)
                    })
                    .buttonBorderShape(.circle)
                    .buttonStyle(GlassButtonStyle())
                    Text("MISSION")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("RULES")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                }
                .padding(.top, 20)
                CardView(description: "Each focus session → a flight", image: "onboarding_3_1", width: geometry.size.width - 40, height: 200, offsetX: 0.0, offsetY: 0.4, step: step)
                    .padding(.top, 6)
                CardView(description: "Stay in the cockpit → Mission success", image: "onboarding_3_2", width: geometry.size.width - 40, height: 200, offsetX: 0.0, offsetY: 0.1, step: step)
                    .padding(.top, 6)
                CardView(description: "Leave the app → Mission fails", image: "onboarding_3_3", width: geometry.size.width - 40, height: 200, offsetX: 0.2, offsetY: 0.0, step: step)
                    .padding(.top, 6)
                Spacer()
                Button(action: {
                    router.navigate(to: Route.onboarding(Route.OnboardingScreen.fourth))
                }, label: {
                    Text("🫡 Got it!")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                })
                .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
        .onAppear {
            withAnimation(.linear(duration: 0.8)) {
                step = 0.0
            }
        }
    }
}

#Preview {
    OnboardingScreenThird()
}
