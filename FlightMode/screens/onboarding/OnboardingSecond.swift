//
//  onboarding_2.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 16.12.2025.
//

import SwiftUI

struct Card: View, Animatable {
    
    var a: Double
    var description: String
    var image: Image
    var step: Double
    var rank: Int
    var angle: Double
    
    let B: Double = 1
    
    var animatableData: Double {
        get {
            step
        }
        set {
            step = newValue
        }
    }
    
    func getOffset() -> Double {
        return -Double(rank) * a * cos(angle) / 2 * (cos(step * step))
    }
    
    var body: some View {
        if #available(iOS 26, *) {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Text(description)
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                }
                .frame(width: max(a - 20, 0), alignment: .leading)
                image
                    .resizable()
                    .frame(width: a * 3/4, height: a * 3/4)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.vertical, 10)
            .frame(width: a, height: a)
            .rotationEffect(Angle(degrees: -15))
            .glassEffect(.regular.tint(Color(hex: "0E0E0E")), in: RoundedRectangle(cornerRadius: 12).rotation(Angle(degrees: -15), anchor: .center))
            .offset(x: a * 0.6 + getOffset(), y: 0)
        } else {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Text(description)
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                }
                .frame(width: max(a - 20, 0), alignment: .leading)
                image
                    .resizable()
                    .frame(width: a * 3/4, height: a * 3/4)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.vertical, 10)
            .frame(width: a, height: a)
            .background(Color(hex: "0E0E0E").opacity(0.8))
            .background(LinearGradient(gradient: Gradient(colors: [
                Color(hex: "EBF0FF").opacity(0.6),
                Color(hex: "C8CCFF").opacity(0.5),
                Color(hex: "D9D7FF").opacity(0.4),
            ]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(12)
            .rotationEffect(Angle(radians: -angle))
            .offset(x: a * 0.6 + getOffset(), y: 0)
        }
    }
}


struct OnboardingScreenSecond : View {
    
    @EnvironmentObject var router: Router
    
    @State private var step: Double = .pi / 2
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(alignment: .leading) {
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
                    HStack {
                        Text("DO YOU STRUGGLE TO")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        + Text(" STAY FOCUSED?")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFAE17"))
                    }
                    .animation(nil, value: step)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                Text("In FlightMode, every focus session becomes a flight.")
                    .padding(.horizontal, 40)
                    .padding(.top, 6)
                    .font(.custom("Montserrat", size: 20))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .animation(nil, value: step)
                ZStack {
                    Card(a: geometry.size.width * 0.48, description: "Set timer", image: Image("onboarding_2_timer"), step: step, rank: 3, angle: 15 * Double.pi / 180)
                    Card(a: geometry.size.width * 0.48, description: "Take off", image: Image("onboarding_2_plane"), step: step, rank: 2, angle: 15 * Double.pi / 180)
                    Card(a: geometry.size.width * 0.48, description: "Reach real airports", image: Image("onboarding_2_earth"), step: step, rank: 1, angle: 15 * Double.pi / 180)
                }
                .frame(width: geometry.size.width, height: geometry.size.width * 0.48 * (sin(15 * Double.pi / 180) + cos(15 * Double.pi / 180)), alignment: .trailing)
                Spacer()
                if #available(iOS 26, *) {
                    Button(action: {
                        router.navigate(to: Route.onboarding(Route.OnboardingScreen.third))
                    }, label: {
                        Text("Let's start")
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
                        router.navigate(to: Route.onboarding(Route.OnboardingScreen.third))
                    }, label: {
                        Text("Let's start")
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "0E0E0E"))
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    step = 0.0
                }
            }
        }
    }
}


#Preview {
    OnboardingScreenSecond()
}
