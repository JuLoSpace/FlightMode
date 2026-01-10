//
//  destinationOverlay.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 09.01.2026.
//


import SwiftUI


struct DestinationOverlay: View {
    
    @EnvironmentObject var airportsService: AirportsService
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                Image("successFlight")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(1.5)
                VStack(alignment: .leading) {
                    Text("FLIGHT COMPLETE")
                        .font(.custom("Wattauchimma", size: 36))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                    Text("✅ Perfect flight")
                        .font(.custom("Montserrat", size: 18))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                    Spacer()
                    if let flight = airportsService.currentFlight {
                        TicketView(width: .infinity, height: 200, flight: flight)
                            .padding(.horizontal, 20)
                    }
                    Text("Rewards earned")
                        .font(.custom("Montserrat", size: 14))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                    if #available(iOS 26, *) {
                        HStack(alignment: .center) {
                            Image("ace")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .rotationEffect(.degrees(20))
                                .padding(.all, 5)
                                .background(Color(hex: "FFAE17"))
                                .clipShape(.circle)
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Ace pilot → ")
                                        .font(.custom("Montserrat", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    +
                                    Text("Legend")
                                        .font(.custom("Montserrat", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white.opacity(0.25))
                                    Spacer()
                                    Text("278")
                                        .font(.custom("Montserrat", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    +
                                    Text(" + 1")
                                        .font(.custom("Montserrat", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "FFAE17"))
                                }
                                Color.white.opacity(0.25)
                                    .frame(height: 10)
                                    .cornerRadius(5)
                                    .overlay(alignment: .leading) {
                                        Color(hex: "FFAE17")
                                            .frame(width: 60, height: 8)
                                            .cornerRadius(4)
                                            .padding(.horizontal, 2)
                                    }
                                    .padding(.top, 6)
                                    .padding(.bottom, 2)
                                HStack {
                                    Text("150")
                                        .font(.custom("Montserrat", size: 12))
                                        .fontWeight(.regular)
                                        .foregroundStyle(.white.opacity(0.5))
                                    Spacer()
                                    Text("300")
                                        .font(.custom("Montserrat", size: 12))
                                        .fontWeight(.regular)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                        .padding(.vertical, 8)
                        .glassEffect(.clear)
                        .padding(.horizontal, 20)
                        HStack {
                            Text("+550 Miles")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(LinearGradient(gradient: Gradient(colors: [
                                    Color(hex: "FFAE17").opacity(0.0),
                                    Color(hex: "FFAE17").opacity(1.0)
                                ]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(.infinity)
                            Text("+45 XP")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(LinearGradient(gradient: Gradient(colors: [
                                    Color(hex: "FFAE17").opacity(0.0),
                                    Color(hex: "FFAE17").opacity(1.0)
                                ]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(.infinity)
                        }
                        .padding(.horizontal, 20)
                        if #available(iOS 26, *) {
                            Button(action: {
                                onTabCallback(TabWidgetType.home)
                                airportsService.cancel()
                            }, label: {
                                Text("Continue")
                                    .font(.custom("Montserrat", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                            })
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(hex: "151515"))
    }
}


#Preview {
    DestinationOverlay { _ in
        
    }
}
