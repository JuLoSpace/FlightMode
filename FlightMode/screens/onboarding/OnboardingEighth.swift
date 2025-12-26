//
//  onboarding_8.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 23.12.2025.
//

import SwiftUI

struct OnboardingScreenEighth : View {
    
    @State var step: Double = 1.0
    @EnvironmentObject var router: Router
    @State var timeAngle: Double = 0
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
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack {
                    Text("DAILY MISSIONS?")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                }
                Spacer()
                ZStack(alignment: .bottom) {
                    Image("onboarding_8_1")
                    .resizable()
                    .frame(width: geometry.size.width - 40)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        ZStack(alignment: .center) {
                            ForEach(0..<24, id: \.self) { index in
                                let angle: Double = (-15 * Double(index) - timeAngle)
                                let currentElement: Int = Int(-timeAngle) / 15
                                if abs(angle) < 45 {
                                    Text(index < 10 ? "0\(index):00" : "\(index):00")
                                        .font(.custom("Montserrat", size: 70))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .rotation3DEffect(Angle(degrees: angle), axis: (x: 1.0, y: 0.0, z: 0.0))
                                        .offset(y: -150 * sin(angle / 24.0))
                                        .opacity(1.0 - Double(abs(index - currentElement)) * 0.6)
                                }
                            }
                        }
                        .frame(width: geometry.size.width - 40, height: 270)
                        .mask {
                            Rectangle()
                                .frame(height: 260)
                        }
                        .offset(y: 50)
                        .clipped()
                    }
                    .offset(y: 100 + geometry.size.height * sin(step))
                    .gesture(
                        DragGesture().onChanged { value in
                            isMoving = true
                            timeAngle += value.translation.height * 0.01
                        }
                        .onEnded { value in
                            isMoving = false
                            timeAngle = min(max(Double(Int(timeAngle) - (Int(timeAngle) % 15)), -345), 0)
                        }
                    )
                    .animation(.easeInOut, value: timeAngle)
                    .shadow(color: Color(hex: "FFA600").opacity(0.15), radius: 100, x: -40.0, y: -40.0)
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
                        .glassEffect(.clear.tint(Color(hex: "FFAE17")).interactive())
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
                        .glassEffect(.clear.tint(Color(hex: "3D3D3D")).interactive())
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
