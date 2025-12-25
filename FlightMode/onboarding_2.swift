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
        let offsetX: Double = (a * Double(rank)) / (2 * cos(90 - angle))
        let A: Double = (a + offsetX) / (cos(B) - 1)
        let C: Double = -offsetX - (a + offsetX) / (cos(B) - 1)
        if step != 0 {
            return A * cos(B * step) + C
        } else {
            return -offsetX
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(description)
                .font(.custom("Montserrat", size: 16))
                .foregroundStyle(.white)
                .fontWeight(.bold)
            image
                .resizable()
                .frame(width: a * 3/4, height: a * 3/4)
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(width: a, height: a)
        .rotationEffect(Angle(degrees: -15))
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 12).rotation(Angle(degrees: -15), anchor: .center))
        .offset(x: getOffset())
    }
}


struct OnboardingScreenSecond : View {
    
    @EnvironmentObject var router: Router
    
    @State private var step: Double = 1
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        router.navigateBack()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .padding(.all, 6)
                    })
                    .buttonBorderShape(.circle)
                    .buttonStyle(GlassButtonStyle())
                    .padding(.top, 20)
                    HStack {
                        Text("DO YOU STRUGGLE TO")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    HStack {
                        Text("STAY FOCUSED?")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFAE17"))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                Text("In FlightApp, every focus session becomes a flight.")
                    .padding(.horizontal, 40)
                    .padding(.top, 12)
                    .font(.custom("Montserrat", size: 20))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                ZStack {
                    Card(a: geometry.size.width * 0.44, description: "Set timer", image: Image("onboarding_2_timer"), step: step, rank: 2, angle: 15)
                    Card(a: geometry.size.width * 0.44, description: "Take off", image: Image("onboarding_2_plane"), step: step, rank: 1, angle: 15)
                    Card(a: geometry.size.width * 0.44, description: "Reach real airports", image: Image("onboarding_2_earth"), step: step, rank: 0, angle: 15)
                }
                .frame(width: geometry.size.width, alignment: .trailing)
                .padding(.top, 20)
                Spacer()
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
                .glassEffect(.clear.tint(Color(hex: "FFAE17")).interactive())
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "0E0E0E"))
            .onAppear {
                withAnimation(.linear(duration: 0.8)) {
                    step = 0
                }
            }
        }
    }
}


#Preview {
    OnboardingScreenSecond()
}
