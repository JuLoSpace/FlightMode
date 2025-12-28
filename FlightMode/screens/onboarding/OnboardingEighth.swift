//
//  onboarding_8.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 23.12.2025.
//

import SwiftUI

struct OnboardingScreenEighth : View {
    
    @State var step: Double = Double.pi / 2
    @EnvironmentObject var router: Router
    @State var hoursAngle: Double = 0.0
    @State var minutesAngle: Double = 0.0
    @State var isMoving: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Button(action: {
                    router.navigateBack()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .padding(.all, 6)
                })
                .buttonBorderShape(.circle)
                .buttonStyle(GlassButtonStyle())
                .font(.system(size: 24))
                .padding(.top, 20)
                HStack {
                    Text("WHEN SHOULD WE REMIND YOU ABOUT YOUR")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack {
                    Text("DAILY MISSIONS?")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                }
                Spacer()
                ZStack(alignment: .bottom) {
                    Image("onboarding_8_1")
                    .resizable()
                    .frame(width: max(geometry.size.width - 40, 0))
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        HStack(alignment: .center, spacing: 0) {
                            ZStack(alignment: .center) {
                                ForEach(0..<24, id: \.self) { index in
                                    let angle: Double = (-15.0 * Double(index) - hoursAngle)
                                    let currentElement: Int = Int(-hoursAngle) / 15
                                    let hoursString = index < 10 ? "0" + String(index) : String(index)
                                    let r: Int = abs(index - currentElement)
                                    let m: Double = min(abs(angle), 360 - abs(angle))
                                    if abs(m) < 45 {
                                        Text("\(hoursString)")
                                            .font(.custom("Montserrat", size: 70))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .rotation3DEffect(Angle(degrees: angle), axis: (x: 1.0, y: 0.0, z: 0.0))
                                            .offset(y: 300 * sin(-angle * Double.pi / 180.0))
                                            .opacity(1.0 - Double(abs(m / 15.0)) * 0.6)
                                    }
                                }
                            }
                            .frame(width: max(geometry.size.width / 2.0 - 20.0, 0), height: 270, alignment: .trailing)
                            .padding(.trailing, 10)
                            .mask {
                                Rectangle()
                                    .frame(height: 260)
                            }
                            .offset(y: 50)
                            .clipped()
                            ZStack(alignment: .center) {
                                ForEach(0..<60, id: \.self) { index in
                                    let angle: Double = (-6 * Double(index) - minutesAngle)
                                    let currentElement: Int = Int(-minutesAngle) / 6
                                    let minutesString = index < 10 ? "0" + String(index) : String(index)
                                    let r: Int = abs(index - currentElement)
                                    let m: Double = min(abs(angle), 360 - abs(angle))
                                    if abs(m) < 45 {
                                        Text("\(minutesString)")
                                            .font(.custom("Montserrat", size: 70))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .rotation3DEffect(Angle(degrees: angle), axis: (x: 1.0, y: 0.0, z: 0.0))
                                            .offset(y: 750 * sin(-angle * Double.pi / 180.0))
                                            .opacity(1.0 - Double(abs(m / 6.0)) * 0.6)
                                    }
                                }
                            }
                            .frame(width: max(geometry.size.width / 2.0 - 20.0, 0), height: 270, alignment: .leading)
                            .padding(.leading, 10)
                            .mask {
                                Rectangle()
                                    .frame(height: 260)
                            }
                            .offset(y: 50)
                            .clipped()
                        }
                    }
                    .offset(y: 100 + geometry.size.height * sin(step))
                    .gesture(
                        DragGesture().onChanged { value in
                            isMoving = true
                            if (value.location.x / geometry.size.width < 0.5) {
                                hoursAngle += value.velocity.height * 0.005 // changing position with speed is more comfortable for usage
                                if (hoursAngle < 0.0) {
                                    hoursAngle += 360.0
                                }
                                if (hoursAngle > 360.0) {
                                    hoursAngle -= 360.0
                                }
                            } else {
                                minutesAngle += value.velocity.height * 0.002 // changing position with speed is more comfortable for usage
                                if (minutesAngle < 0.0) {
                                    minutesAngle += 360.0
                                }
                                if (minutesAngle > 360.0) {
                                    minutesAngle -= 360.0
                                }
                            }
                        }
                        .onEnded { value in
                            isMoving = false
                            hoursAngle = Double(Int(hoursAngle) - (Int(hoursAngle) % 15))
                            minutesAngle = Double(Int(minutesAngle) - (Int(minutesAngle) % 6))
                        }
                    )
                    .animation(.easeOut(duration: 0.4), value: hoursAngle)
                    .animation(.easeOut(duration: 0.4), value: minutesAngle)
                    .shadow(color: Color(hex: "FFA600").opacity(0.15), radius: 60, x: 0.0, y: -40.0)
                    .sensoryFeedback(.impact(weight: .heavy), trigger: Int(hoursAngle / 15))
                    .sensoryFeedback(.impact(weight: .medium), trigger: Int(minutesAngle / 15))
                    HStack {
                        Button(action: {
                            router.navigate(to: Route.onboarding(Route.OnboardingScreen.nineth))
                        }, label: {
                            Text("Got it!")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                        })
                        .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                        Button(action: {
                            router.navigate(to: Route.onboarding(Route.OnboardingScreen.nineth))
                        }, label: {
                            Text("Skip")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                        })
                        .glassEffect(.regular.tint(Color(hex: "3D3D3D")).interactive())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                step = 0.0
            }
        }
    }
}


#Preview {
    OnboardingScreenEighth()
}
