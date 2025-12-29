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
    
    @State var selectedPromotionalSubscriptionType: SubscriptionType?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text("WAIT")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    +
                    Text(", CADET!")
                        .font(.custom("Wattauchimma", size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFAE17"))
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
                Text("Special Offer Just Unlocked. As a first-time pilot, you get exclusive discounted pricing:")
                    .font(.custom("Montserrat", size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .padding(.top, 10)
                if user.availablePromotionalSubscriptions[SubscriptionType.weekly] ?? false && user.availableSubscriptions[SubscriptionType.weekly] ?? false {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Weekly")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("Save \(100 - Int(100.0 * user.getPromotionalSubscription(subscriptionType: .weekly).amount / user.getSubscription(subscriptionType: .weekly).amount))%")
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
                            Text("\(user.getPromotionalSubscription(subscriptionType: .weekly).price) / week")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "FFAE17"))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .frame(width: geometry.size.width - 80, alignment: .topLeading)
                    .glassEffect(.regular.tint(Color.white.opacity(0.2)), in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        if selectedPromotionalSubscriptionType == .weekly {
                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                        }
                    }
                    .padding(.top, 20)
                    .onTapGesture {
                        selectedPromotionalSubscriptionType = .weekly
                    }
                }
                if user.availablePromotionalSubscriptions[SubscriptionType.monthly] ?? false && user.availableSubscriptions[SubscriptionType.monthly] ?? false {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Monthly - Best value")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("Save \(100 - Int(100.0 * user.getPromotionalSubscription(subscriptionType: .monthly).amount / user.getSubscription(subscriptionType: .monthly).amount))%")
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
                            Text("\(user.getPromotionalSubscription(subscriptionType: .monthly).price) / month")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "FFAE17"))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .frame(width: geometry.size.width - 80, alignment: .topLeading)
                    .glassEffect(.regular.tint(Color.white.opacity(0.2)), in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        if selectedPromotionalSubscriptionType == .monthly {
                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                        }
                    }
                    .padding(.top, 20)
                    .onTapGesture {
                        selectedPromotionalSubscriptionType = .monthly
                    }
                }
                if user.availablePromotionalSubscriptions[SubscriptionType.yearly] ?? false && user.availableSubscriptions[SubscriptionType.yearly] ?? false {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Yearly - Max savings")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("Save \(100 - Int(100.0 * user.getPromotionalSubscription(subscriptionType: .yearly).amount / user.getSubscription(subscriptionType: .yearly).amount))%")
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
                            Text("\(user.getPromotionalSubscription(subscriptionType: .yearly).price) / year")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "FFAE17"))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .frame(width: geometry.size.width - 80, alignment: .topLeading)
                    .glassEffect(.regular.tint(Color.white.opacity(0.2)), in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        if selectedPromotionalSubscriptionType == .yearly {
                            RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "FFAE17"), lineWidth: 2)
                        }
                    }
                    .padding(.top, 20)
                    .onTapGesture {
                        selectedPromotionalSubscriptionType = .yearly
                    }
                }
                HStack {
                    Spacer()
                    Text("Offer expires in: ")
                        .font(.custom("Montserrat", size: 12))
                        .fontWeight(.regular)
                        .foregroundStyle(Color(hex: "FFAE17"))
                        .padding(.top, 10)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .frame(width: geometry.size.width - 40, alignment: .topLeading)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
    }
    
}


#Preview {
    PromotionalPaywallScreen()
}
