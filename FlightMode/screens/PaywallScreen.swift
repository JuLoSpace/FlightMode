//
//  paywall.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 24.12.2025.
//

import SwiftUI
import Combine


struct PaywallCard {
    var image: Image?
    var title: String?
    var description: String?
}


struct PaywallScreen : View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var user: UserModel
    @State var step: Double = 1.0
    @State var wallIndex: Int = 0
    @State private var timer: Timer?
    @State private var scrollPosition = ScrollPosition(edge: .leading)
    
    @State var scrollWidth: Double?
    
    @State var isAnimatable: Bool = true
    
    @State var selectedSubscriptionType: SubscriptionType?
    
    var paywallCards: [PaywallCard] = [
        PaywallCard(
            image: Image("paywall_1"),
            title: "UNLIMITED FOCUS FLIGHTS - FLY ANYTIME",
            description: "Take off into deep focus without limits."
        ),
        PaywallCard(
            image: Image("paywall_2"),
            title: "CAPTAIN AVATARS — CHOOSE YOUR INENTITY",
            description: "Take off into deep focus without limits."
        ),
        PaywallCard(
            image: Image("paywall_3"),
            title: "COCKPIT + REAL-TIME MAP VIEWS",
            description: "Take off into deep focus without limits."
        ),
        PaywallCard(
            image: Image("paywall_4"),
            title: "EXTENDED AIRPLANE SOUNDSCAPES",
            description: "Take off into deep focus without limits."
        ),
        PaywallCard(
            title: "All WIDGETS & STANDBY MODES",
            description: "Take off into deep focus without limits."
        ),
        PaywallCard(
            title: "DATA TRACKING & ANALYSIS",
            description: "Take off into deep focus without limits."
        ),
    ]
    
    private func startWallAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            if isAnimatable {
                withAnimation(.linear(duration: 1.0)) {
                    wallIndex = (wallIndex + 1) % 5
                }
                if let width = scrollWidth {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scrollPosition.scrollTo(x: width * Double(wallIndex))
                    }
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        user.restorePurchases()
                    }, label: {
                        Text("Restore")
                            .font(.custom("Montserrat", size: 16))
                            .foregroundStyle(.white.opacity(0.5))
                            .background(.clear)
                    })
                    Spacer()
                    Button(action: {
                        router.navigateBack()
                    }, label: {
                        Image(systemName: "xmark")
                            .padding(.all, 6)
                    })
                    .buttonBorderShape(.circle)
                    .buttonStyle(GlassButtonStyle())
                    .font(.system(size: 24))
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                Text("PREMIUM ACCESS")
                    .font(.custom("Wattauchimma", size: 48))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(0..<paywallCards.count, id: \.self) { i in
                            ZStack {
                                VStack(alignment: .trailing) {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: "FFA600").opacity(0.35),
                                                    .clear
                                                ]), center: .center, startRadius: 0, endRadius: geometry.size.height * 0.2)
                                        )
                                        .blur(radius: geometry.size.height * 0.08)
                                        .offset(x: geometry.size.height * 0.2, y: geometry.size.height * 0.1)
                                }
                                .frame(width: geometry.size.width - 40, height: geometry.size.height * 0.42, alignment: .bottomTrailing)
                                VStack(alignment: .leading, spacing: 0) {
                                    VStack(alignment: .center) {
                                        if let image = paywallCards[i].image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    }
                                    .frame(width: geometry.size.width - 60)
                                    if let title = paywallCards[i].title {
                                        Text(title)
                                            .font(.custom("Wattauchimma", size: 24))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.top, 10)
                                    }
                                    if let description = paywallCards[i].description {
                                        Text(description)
                                            .font(.custom("Montserrat", size: 16))
                                            .fontWeight(.light)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.top, 10)
                                    }
                                }
                                .padding(.vertical, 20)
                                .frame(width: geometry.size.width - 40, height: geometry.size.height * 0.42)
                                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal, 20)
                            }
                            .frame(width: geometry.size.width - 40, height: geometry.size.height * 0.42)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .clipped()
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .scrollPosition($scrollPosition)
                .scrollDisabled(true)
                .onScrollGeometryChange(for: CGPoint.self) { geo in
                    return geo.contentOffset
                } action: { oldValue, newValue in
//                    if (geometry.size.width != 0.0) {
//                        let index: Int = Int(round(newValue.x / geometry.size.width))
//                        wallIndex = index
//                        timer?.invalidate()
//                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                scrollPosition.scrollTo(x: geometry.size.width * Double(wallIndex))
//                            }
//                        }
//                    }
                }
                HStack {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.white.opacity(i == wallIndex ? 1.0 : 0.5))
                    }
                }
                .padding(.top, 10)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        if let exist = user.getAvailableSubscriptions()[SubscriptionType.weekly] {
                            ZStack(alignment: .top) {
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading) {
                                        Text("Weekly")
                                            .font(.custom("Montserrat", size: 16))
                                            .foregroundStyle(.white)
                                        Text("\(user.getSubscription(subscriptionType: SubscriptionType.weekly).price)")
                                            .font(.custom("Montserrat", size: 18))
                                            .foregroundStyle(Color(hex: "#FFAE17"))
                                            .fontWeight(.bold)
                                        Text("Per week")
                                            .font(.custom("Montserrat", size: 12))
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                    .padding(.top, 26)
                                    .padding(.bottom, 12)
                                    .padding(.leading, 24)
                                    .frame(width: geometry.size.width * 0.4, alignment: .leading)
                                    .background(Color(hex: "#202020"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay {
                                        if (selectedSubscriptionType == SubscriptionType.weekly) {
                                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#FFAE17"), lineWidth: 2)
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                                .frame(width: geometry.size.width * 0.45)
                            }
                            .onTapGesture {
                                selectedSubscriptionType = SubscriptionType.weekly
                            }
                        }
                        if let exist = user.getAvailableSubscriptions()[SubscriptionType.monthly] {
                            ZStack(alignment: .top) {
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading) {
                                        Text("Monthly")
                                            .font(.custom("Montserrat", size: 16))
                                            .foregroundStyle(.white)
                                        Text("\(user.getSubscription(subscriptionType: SubscriptionType.monthly).price)")
                                            .font(.custom("Montserrat", size: 18))
                                            .foregroundStyle(Color(hex: "#FFAE17"))
                                            .fontWeight(.bold)
                                        Text("Per month")
                                            .font(.custom("Montserrat", size: 12))
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                    .padding(.top, 26)
                                    .padding(.bottom, 12)
                                    .padding(.leading, 24)
                                    .frame(width: geometry.size.width * 0.4, alignment: .leading)
                                    .background(Color(hex: "#202020"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay {
                                        if (selectedSubscriptionType == SubscriptionType.monthly) {
                                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#FFAE17"), lineWidth: 2)
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                                .frame(width: geometry.size.width * 0.45)
                                HStack {
                                    Text("Save 37%")
                                        .font(.custom("Montserrat", size: 10))
                                        .foregroundStyle(.white)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color(hex: "#202020"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16).stroke(.white, lineWidth: 1)
                                        }
                                    Text("Popular")
                                        .font(.custom("Montserrat", size: 10))
                                        .foregroundStyle(Color(hex: "#FFAE17"))
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color(hex: "#202020"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#FFAE17"), lineWidth: 1)
                                        }
                                }
                            }
                            .onTapGesture {
                                selectedSubscriptionType = SubscriptionType.monthly
                            }
                        }
                        if let exist = user.getAvailableSubscriptions()[SubscriptionType.yearly] {
                            ZStack(alignment: .top) {
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading) {
                                        Text("Yearly")
                                            .font(.custom("Montserrat", size: 16))
                                            .foregroundStyle(.white)
                                        Text("\(user.getSubscription(subscriptionType: SubscriptionType.yearly).price)")
                                            .font(.custom("Montserrat", size: 18))
                                            .foregroundStyle(Color(hex: "#FFAE17"))
                                            .fontWeight(.bold)
                                        Text("Per year")
                                            .font(.custom("Montserrat", size: 12))
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                    .padding(.top, 26)
                                    .padding(.bottom, 12)
                                    .padding(.leading, 24)
                                    .frame(width: geometry.size.width * 0.4, alignment: .leading)
                                    .background(Color(hex: "#202020"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay {
                                        if (selectedSubscriptionType == SubscriptionType.yearly) {
                                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#FFAE17"), lineWidth: 2)
                                        }
                                    }
                                    .padding(.top, 12)
                                }
                                .frame(width: geometry.size.width * 0.45)
                                HStack {
                                    Text("Save 74% (4.16$/m)")
                                        .font(.custom("Montserrat", size: 10))
                                        .foregroundStyle(.white)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color(hex: "#202020"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16).stroke(.white, lineWidth: 1)
                                        }
                                }
                            }
                            .onTapGesture {
                                selectedSubscriptionType = SubscriptionType.yearly
                            }
                        }
                    }
                }
                .padding(.top, 10)
                Spacer()
                Button(action: {
                    if let type = selectedSubscriptionType {
                        user.makePurchase(subscriptionType: type)
                    }
                }, label: {
                    Text("🚀 Start 3-Day Free Trial")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                })
                .glassEffect(.clear.tint(selectedSubscriptionType != nil ? Color(hex: "FFAE17") : Color(hex: "3D3D3D")).interactive())
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                HStack(alignment: .center) {
                    Button(action: {
                        
                    }, label: {
                        Text("Privacy")
                            .font(.custom("Montserrat", size: 12))
                            .foregroundStyle(.white.opacity(0.75))
                    })
                    .background(.clear)
                    Text("|")
                        .font(.custom("Montserrat", size: 12))
                        .foregroundStyle(.white.opacity(0.75))
                    Button(action: {
                        
                    }, label: {
                        Text("Terms")
                            .font(.custom("Montserrat", size: 12))
                            .foregroundStyle(.white.opacity(0.75))
                    })
                    .background(.clear)
                    Spacer()
                    Text("Cancel anytime • Auto-renews")
                        .font(.custom("Montserrat", size: 12))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                if scrollWidth == nil && geometry.size.width != 0 {
                    scrollWidth = geometry.size.width
                }
                startWallAnimation()
            }
            .onChange(of: geometry.size.width, initial: true) { _, newWidth in
                if scrollWidth == nil && newWidth != 0 {
                    scrollWidth = newWidth
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
    }
}

#Preview {
    PaywallScreen()
}
