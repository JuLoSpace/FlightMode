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
        if #available(iOS 26, *) {
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
        } else {
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
            .background(Color(hex: "0E0E0E").opacity(0.8))
            .background(LinearGradient(gradient: Gradient(colors: [
                Color(hex: "EBF0FF").opacity(0.6),
                Color(hex: "C8CCFF").opacity(0.5),
                Color(hex: "D9D7FF").opacity(0.4),
            ]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(16)
            .frame(width: width, height: height)
            .clipped()
        }
    }
}


struct OnboardingScreenThird : View {
    
    @EnvironmentObject var router: Router
    
    @State private var step: Double = Double.pi / 2
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    if #available(iOS 26, *) {
                        Button(action: {
                            router.navigateBack()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .buttonBorderShape(.circle)
                        .buttonStyle(GlassButtonStyle())
                        .animation(nil, value: step)
                    } else {
                        Button(action: {
                            router.navigateBack()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .foregroundStyle(.white)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.bordered)
                        .animation(nil, value: step)
                    }
                    Text("MISSION")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .animation(nil, value: step)
                    Spacer()
                    Text("RULES")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                        .animation(nil, value: step)
                }
                CardView(description: "Each focus session → a flight", image: "onboarding_3_1", width: geometry.size.width - 40, height: 200, offsetX: 0.0, offsetY: 0.4, step: step)
                    .padding(.top, 6)
                    .animation(nil, value: step)
                CardView(description: "Stay in the cockpit → Mission success", image: "onboarding_3_2", width: geometry.size.width - 40, height: 200, offsetX: 0.0, offsetY: 0.1, step: step)
                    .padding(.top, 6)
                    .animation(nil, value: step)
                CardView(description: "Leave the app → Mission fails", image: "onboarding_3_3", width: geometry.size.width - 40, height: 200, offsetX: 0.2, offsetY: 0.0, step: step)
                    .padding(.top, 6)
                    .animation(nil, value: step)
                Spacer()
                if #available(iOS 26, *) {
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
                    .animation(nil, value: step)
                } else {
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
                    .buttonStyle(CustomButtonStyle(color: Color(hex: "FFAE17").opacity(0.7)))
                    .padding(.horizontal, 20)
                    .animation(nil, value: step)
                }
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
