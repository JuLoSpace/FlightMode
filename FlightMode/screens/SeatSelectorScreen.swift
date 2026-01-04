//
//  SeatSelectorScreen.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 04.01.2026.
//

import SwiftUI

struct Seat: View {
    
    let width: Double = 45.0
    let height: Double = 40.0
    
    let callback: () -> ()
    
    var body: some View {
        ZStack {
            Color(hex: "2F2F2F")
                .frame(width: width, height: height - 4)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack(spacing: 0) {
                Color(hex: "474747")
                    .frame(width: 8, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                VStack {
                    Spacer()
                    Color(hex: "6E6E6E")
                        .frame(width: 20, height: 8)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
                Color(hex: "474747")
                    .frame(width: 8, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(width: width, height: height)
        .onTapGesture {
            
        }
    }
}

struct SeatSelectorScreen: View {
    
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    if #available(iOS 26, *) {
                        Button(action: {
                            onTabCallback(TabWidgetType.flight(.selectAirport))
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .buttonBorderShape(.circle)
                        .buttonStyle(GlassButtonStyle())
                        .padding(.horizontal, 20)
                    } else {
                        Button(action: {
                            onTabCallback(TabWidgetType.flight(.selectAirport))
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .foregroundStyle(.white)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 20)
                    }
                    VStack {
                        VStack {
                            Text("CHOOSE YOUR SEAT IN COCKPIT ")
                                .font(.custom("Wattauchimma", size: 40))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            +
                            Text("BOEING 737")
                                .font(.custom("Wattauchimma", size: 40))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "FFAE17"))
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                        Image("airplane")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.6, alignment: .top)
                            .clipped()
                            .scaleEffect(1.6)
                            .overlay {
                                VStack(alignment: .center, spacing: 40) {
                                    HStack(spacing: 20) {
                                        Seat(callback: {
                                            
                                        })
                                        Seat(callback: {
                                            
                                        })
                                    }
                                    HStack {
                                        VStack(spacing: 10) {
                                            ForEach(0..<6, id: \.self) { i in
                                                HStack(spacing: 20) {
                                                    Seat(callback: {
                                                        
                                                    })
                                                    Seat(callback: {
                                                        
                                                    })
                                                }
                                            }
                                        }
                                        Spacer()
                                        VStack(spacing: 10) {
                                            ForEach(0..<6, id: \.self) { i in
                                                HStack(spacing: 20) {
                                                    Seat(callback: {
                                                        
                                                    })
                                                    Seat(callback: {
                                                        
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.6, alignment: .bottom)
                            }
                    }
                }
                VStack {
                    if #available(iOS 26, *) {
                        Button(action: {
                            onTabCallback(TabWidgetType.flight(.ticket))
                        }, label: {
                            Text("Continue")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(height: 60)
                        })
                        .frame(width: max(geometry.size.width - 40, 0))
                        .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                        .padding(.horizontal, 20)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(hex: "0E0E0E"))
    }
}


#Preview {
    SeatSelectorScreen { _ in
        
    }
}
