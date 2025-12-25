//
//  onboarding_9.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 24.12.2025.
//

import SwiftUI


struct SpeechBubbleRight : Shape {
    
    var cornerRadius: CGFloat = 20.0
    var tailSize: CGFloat = 20.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width - cornerRadius - tailSize, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius - tailSize, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width - tailSize, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - tailSize, y: rect.height - tailSize))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}

struct SpeechBubbleLeft : Shape {
    
    var cornerRadius: CGFloat = 20.0
    var tailSize: CGFloat = 20.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: cornerRadius + tailSize, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius - tailSize, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width - tailSize, y: rect.height))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius - tailSize, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: tailSize, y: rect.height - tailSize))
        return path
    }
}


struct OnboardingScreenNineth : View {
    
    @EnvironmentObject var router: Router
    @State var step: Double = 1.0
    
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
                    Text("READY FOR YOUR")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack {
                    Text("FIRST FLIGHT?")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
                }
                HStack {
                    Text("Cadet, your cockpit is ready. Stay focused. Complete your mission. Earn your wings. Your first successful flight earns +500 bonus miles.")
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.leading, 15)
                .padding(.trailing, 30)
                .padding(.vertical, 15)
                .frame(width: geometry.size.width - 40)
                .background(.white.opacity(0.03))
                .clipShape(SpeechBubbleRight())
                HStack {
                    Text("Good luck, Pilot.")
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading, 15)
                .padding(.trailing, 30)
                .padding(.vertical, 15)
                .frame(width: geometry.size.width - 40)
                .background(.white.opacity(0.03))
                .clipShape(SpeechBubbleRight())
                HStack {
                    Spacer()
                    Image("onboarding_9_1")
                    Text("Pilot")
                        .font(.custom("Montserrat", size: 20))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("🚀 Ready for takeoff!")
                        .font(.custom("Montserrat", size: 16))
                        .foregroundStyle(Color(hex: "FFAE17"))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading, 30)
                .padding(.trailing, 15)
                .padding(.vertical, 15)
                .frame(width: geometry.size.width - 40)
                .background(.white.opacity(0.03))
                .clipShape(SpeechBubbleLeft())
                HStack {
                    Image("onboarding_9_2")
                    Text("You")
                        .font(.custom("Montserrat", size: 20))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
                Button(action: {
                    router.navigate(to: Route.paywall)
                }, label: {
                    Text("🚀 Ready for Takeoff!")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                })
                .glassEffect(.clear.tint(Color(hex: "FFAE17")).interactive())
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
    OnboardingScreenNineth()
}
