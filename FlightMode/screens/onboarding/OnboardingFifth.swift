//
//  onboarding_5.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 18.12.2025.
//

import SwiftUI


struct CareerCard: View {
    
    var image: String
    var name: String
    var flights: Int
    var width: Double
    var height: Double
    
    var body: some View {
        ZStack {
            VStack {
                
            }
            .frame(width: width, height: height)
            .overlay {
                RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.05))
            }
            HStack(alignment: .center) {
                Image(image)
                    .resizable()
                    .rotationEffect(Angle(degrees: 10))
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 5)
                Spacer()
                Text(name)
                    .font(.custom("Montserrat", size: 20))
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Spacer()
                Text("\(flights) flights")
                    .font(.custom("Montserrat", size: 16))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .frame(width: width, height: height + 10)
        }
    }
}


struct OnboardingScreenFifth: View {
    
    @EnvironmentObject var router: Router
    
    @State private var step: Double = 1
    
    var body: some View {
        GeometryReader { geometry in
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
                .padding(.horizontal, 20)
                HStack {
                    Text("YOUR PILOT")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                HStack {
                    Text("CAREER")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                    Spacer()
                }
                .padding(.horizontal, 20)
                Text("Only completed flights count toward your rank.")
                    .padding()
                    .font(.custom("Montserrat", size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                ForEach(Career.allCases, id: \.self) { career in
                    CareerCard(image: career.imageName, name: career.name, flights: career.flights, width: geometry.size.width - 40, height: 60)
                        .padding(.horizontal, 20)
                        .offset(x: geometry.size.width * pow(sin(step), Double((Career.allCases.count - career.index))))
                }
                Spacer()
                Button(action: {
                    router.navigate(to: Route.onboarding(Route.OnboardingScreen.sixth))
                }, label: {
                    Text("🚀 Let’s climb")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                })
                .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                .padding(.horizontal, 20)
            }
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
    OnboardingScreenFifth()
}
