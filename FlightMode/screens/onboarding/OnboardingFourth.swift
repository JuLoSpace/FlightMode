//
//  onboarding_4.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 17.12.2025.
//

import SwiftUI

struct OnboardingScreenFourth: View {
    
    @EnvironmentObject var router: Router
    
    @State private var step: Double = Double.pi / 2
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
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
                        VStack {
                            HStack {
                                Text("ENABLE FOCUS")
                                    .font(.custom("Wattauchimma", size: 44))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            HStack {
                                Text("PROTECTION")
                                    .font(.custom("Wattauchimma", size: 44))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "FFAE17"))
                                Spacer()
                            }
                        }
                        .offset(x: -geometry.size.width * sin(step))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    VStack {
                        Image("onboarding_4_1")
                            .aspectRatio(contentMode: .fill)
                            .offset(y: 145)
                            .frame(width: geometry.size.width)
                            .offset(y: geometry.size.height * sin(step))
                    }
                    .clipped()
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            Button(action: {
                                router.navigate(to: Route.onboarding(Route.OnboardingScreen.fifth))
                            }, label: {
                                Text("Got it!")
                                    .font(.custom("Montserrat", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                            })
                            .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                            Button(action: {
                                router.navigate(to: Route.onboarding(Route.OnboardingScreen.third))
                            }, label: {
                                Text("Not now")
                                    .font(.custom("Montserrat", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                            })
                            .glassEffect(.regular.tint(Color(hex: "3D3D3D")).interactive())
                        }
                    }
                    .frame(height: geometry.size.height, alignment: .bottom)
                    .padding(.horizontal, 20)
                }
            }
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
    OnboardingScreenFourth()
}
