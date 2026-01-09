//
//  PromotionalPaywallScreen.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 29.12.2025.
//

import SwiftUI

struct PromotionalPaywallScreen : View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var user: UserModel
    
    @State var selectedDiscountSubscription: SubscriptionType?
    
    @State var hours: String = "00"
    @State var minutes: String = "00"
    
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                let v = VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("WAIT, ")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        +
                        Text("CADET!")
                            .font(.custom("Wattauchimma", size: 44))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "FFAE17"))
                        Spacer()
                        if #available(iOS 26, *) {
                            Button(action: {
                                router.navigateBack()
                            }, label: {
                                Image(systemName: "xmark")
                                    .padding(.all, 6)
                            })
                            .buttonBorderShape(.circle)
                            .buttonStyle(GlassButtonStyle())
                            .font(.system(size: 24))
                        } else {
                            Button(action: {
                                router.navigateBack()
                            }, label: {
                                Image(systemName: "xmark")
                                    .padding(.all, 6)
                            })
                            .foregroundStyle(.white)
                            .buttonBorderShape(.circle)
                            .buttonStyle(.bordered)
                            .font(.system(size: 24))
                        }
                    }
                    Text("Special Offer Just Unlocked. As a first-time pilot, you get exclusive discounted pricing:")
                        .font(.custom("Montserrat", size: 16))
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                    if user.availableSubscriptions[SubscriptionType.weekly] ?? false && user.discountAvailableSubscriptions[SubscriptionType.weekly] ?? false {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("Weekly")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("Save \(100 - Int(100.0 * user.getDiscountSubscription(subscriptionType: .weekly).amount / user.getSubscription(subscriptionType: .weekly).amount))%")
                                    .font(.custom("Montserrat", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "39383A"))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 13))
                            }
                            HStack(alignment: .center) {
                                Text("\(user.getSubscription(subscriptionType: .weekly).price) / week")
                                    .font(.custom("Montserrat", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.25))
                                Text("→")
                                    .font(.custom("Montserrat", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("\(user.getDiscountSubscription(subscriptionType: .weekly).price) / week")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "FFAE17"))
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .frame(width: max(geometry.size.width - 80, 0), alignment: .topLeading)
                        .adaptiveGlassEffect(color: Color.white.opacity(0.2), shape: RoundedRectangle(cornerRadius: 16))
                        .contentShape(.rect)
                        .overlay {
                            if selectedDiscountSubscription == .weekly {
                                RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                            }
                        }
                        .padding(.top, 20)
                        .onTapGesture {
                            selectedDiscountSubscription = .weekly
                        }
                    }
                    if user.discountAvailableSubscriptions[SubscriptionType.monthly] ?? false && user.availableSubscriptions[SubscriptionType.monthly] ?? false {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("Monthly - Best value")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("Save \(100 - Int(100.0 * user.getDiscountSubscription(subscriptionType: .monthly).amount / user.getSubscription(subscriptionType: .monthly).amount))%")
                                    .font(.custom("Montserrat", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "39383A"))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 13))
                            }
                            HStack(alignment: .center) {
                                Text("\(user.getSubscription(subscriptionType: .monthly).price) / month")
                                    .font(.custom("Montserrat", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.25))
                                Text("→")
                                    .font(.custom("Montserrat", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("\(user.getDiscountSubscription(subscriptionType: .monthly).price) / month")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "FFAE17"))
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .frame(width: max(geometry.size.width - 80, 0), alignment: .topLeading)
                        .adaptiveGlassEffect(color: Color.white.opacity(0.2), shape: RoundedRectangle(cornerRadius: 16))
                        .contentShape(.rect)
                        .overlay {
                            if selectedDiscountSubscription == .monthly {
                                RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                            }
                        }
                        .padding(.top, 20)
                        .onTapGesture {
                            selectedDiscountSubscription = .monthly
                        }
                    }
                    if user.discountAvailableSubscriptions[SubscriptionType.yearly] ?? false && user.availableSubscriptions[SubscriptionType.yearly] ?? false {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("Yearly - Max savings")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("Save \(100 - Int(100.0 * user.getDiscountSubscription(subscriptionType: .yearly).amount / user.getSubscription(subscriptionType: .yearly).amount))%")
                                    .font(.custom("Montserrat", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "39383A"))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 13))
                            }
                            HStack(alignment: .center) {
                                Text("\(user.getSubscription(subscriptionType: .yearly).price) / year")
                                    .font(.custom("Montserrat", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.25))
                                Text("→")
                                    .font(.custom("Montserrat", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("\(user.getDiscountSubscription(subscriptionType: .yearly).price) / year")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(hex: "FFAE17"))
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .frame(width: max(geometry.size.width - 80, 0), alignment: .topLeading)
                        .adaptiveGlassEffect(color: Color.white.opacity(0.2), shape: RoundedRectangle(cornerRadius: 16))
                        .contentShape(.rect)
                        .overlay {
                            if selectedDiscountSubscription == .yearly {
                                RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                            }
                        }
                        .padding(.top, 20)
                        .onTapGesture {
                            selectedDiscountSubscription = .yearly
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Offer expires in: ")
                            .font(.custom("Montserrat", size: 14))
                            .fontWeight(.regular)
                            .foregroundStyle(Color(hex: "FFAE17"))
                            .padding(.top, 10)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("\(hours)")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .background(.white.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .animation(.easeInOut, value: hours)
                        Text(":")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("\(minutes)")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .background(.white.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .animation(.easeInOut, value: minutes)
                        Spacer()
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(width: max(geometry.size.width - 40, 0), alignment: .topLeading)
                if #available(iOS 26, *) {
                    v
                        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                } else {
                    v
                        .background(Color(hex: "0E0E0E").opacity(0.8))
                        .background(LinearGradient(gradient: Gradient(colors: [
                            Color(hex: "EBF0FF").opacity(0.6),
                            Color(hex: "C8CCFF").opacity(0.5),
                            Color(hex: "D9D7FF").opacity(0.4),
                        ]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                }
                Spacer()
                if #available(iOS 26, *) {
                    Button(action: {
                        if let type = selectedDiscountSubscription {
                            user.makePurchase(subscriptionType: type, isDiscount: true)
                        }
                    }, label: {
                        Text("🚀 Claim Discount")
                            .font(.custom("Montserrat", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                    })
                    .glassEffect(.regular.tint(Color(hex: selectedDiscountSubscription != nil ? "FFAE17" : "3D3D3D")).interactive())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                } else {
                    Button(action: {
                        if let type = selectedDiscountSubscription {
                            user.makePurchase(subscriptionType: type, isDiscount: true)
                        }
                    }, label: {
                        Text("🚀 Claim Discount")
                            .font(.custom("Montserrat", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                    })
                    .buttonStyle(CustomButtonStyle(color: (Color(hex: selectedDiscountSubscription != nil ? "FFAE17" : "3D3D3D")).opacity(0.7)))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                Button(action: {
                    router.navigate(to: .home)
                }, label: {
                    Text("No, thanks")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                })
                .background(.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
        .onAppear {
            user.seeDiscount()
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                let seconds: Int = user.promotionalExist()
                let m: Int = seconds / 60
                let h: Int = m / 60
                hours = h < 10 ? "0\(h)" : "\(h)"
                minutes = (m % 60) < 10 ? "0\((m % 60))" : "\((m % 60))"
            }
        }
    }
    
}


#Preview {
    PromotionalPaywallScreen()
}
