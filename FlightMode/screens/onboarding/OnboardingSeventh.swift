//
//  onboarding_7.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 23.12.2025.
//

import SwiftUI

struct OnboardingScreenSeventh : View {
    
    @State var step: Double = Double.pi / 2
    @EnvironmentObject var router: Router
    
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
                    Text("YOUR DATA,")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack {
                    Text("YOUR CONTROL")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                }
                VStack {
                    GlassEffectContainer {
                        HStack {
                            Image("onboarding_7_1")
                            Text("We never collect personal files, photos, messages, contacts, or anything unrelated to your focus sessions. You can change your preferences anytime in Settings.")
                                .font(.custom("Montserrat", size: 14))
                                .foregroundStyle(.white)
                                .padding(.leading, 15)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(width: geometry.size.width - 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.15), lineWidth: 1)
                    }
                }
                VStack(alignment: .leading) {
                    Text("FlightMode collects minimal usage data:")
                        .font(.custom("Montserrat", size: 16))
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                        .offset(x: geometry.size.width * sin(step))
                        .animation(.easeInOut(duration: 0.8).delay(0), value: step)
                    HStack(alignment: .center) {
                        Image("onboarding_7_2")
                        Text("Number of completed flights")
                            .font(.custom("Montserrat", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(width: geometry.size.width - 40)
                    .background(.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .offset(x: geometry.size.width * sin(step))
                    .animation(.easeInOut(duration: 0.8).delay(0.05), value: step)
                    HStack(alignment: .center) {
                        Image("onboarding_7_2")
                        Text("Mission categories you choose")
                            .font(.custom("Montserrat", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(width: geometry.size.width - 40)
                    .background(.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .offset(x: geometry.size.width * sin(step))
                    .animation(.easeInOut(duration: 0.8).delay(0.1), value: step)
                    HStack(alignment: .center) {
                        Image("onboarding_7_3")
                        Text("Time spent in focus mode")
                            .font(.custom("Montserrat", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(width: geometry.size.width - 40)
                    .background(.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .offset(x: geometry.size.width * sin(step))
                    .animation(.easeInOut(duration: 0.8).delay(0.15), value: step)
                }
                .padding(.top, 10)
                Spacer()
                Button(action: {
                    router.navigate(to: Route.onboarding(Route.OnboardingScreen.eighth))
                }, label: {
                    Text("Got it!")
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
            withAnimation(.easeInOut(duration: 0.8)) {
                step = 0.0
            }
        }
    }
    
}



#Preview {
    OnboardingScreenSeventh()
}
