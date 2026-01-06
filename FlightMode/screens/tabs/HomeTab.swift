//
//  HomeTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

struct HomeTab : View {
    
    var onTabCallback: (TabWidgetType) -> ()
    
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        VStack(alignment: .center) {
            if #available(iOS 26, *) {
                Button(action: {
                    onTabCallback(TabWidgetType.flight(locationService.location == nil ? FlightWidgetType.setLocation : FlightWidgetType.selectAirport))
                }, label: {
                    Text("Start flight")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(height: 60)
                })
                .frame(maxWidth: .infinity)
                .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                .padding(.horizontal, 20)
            }
            HStack {
                if #available(iOS 26, *) {
                    Button(action: {
                        onTabCallback(TabWidgetType.home)
                    }, label: {
                        Image("home_tab")
                    })
                    .frame(width: 70, height: 70)
                    .contentShape(.circle)
                    .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                }
                if #available(iOS 26, *) {
                    Button(action: {
                        onTabCallback(TabWidgetType.flightAcademy)
                    }, label: {
                        Image("academy_tab")
                    })
                    .frame(width: 70, height: 70)
                    .contentShape(.circle)
                    .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
                }
                if #available(iOS 26, *) {
                    Button(action: {
                        onTabCallback(TabWidgetType.history)
                    }, label: {
                        Image("history_tab")
                    })
                    .frame(width: 70, height: 70)
                    .contentShape(.circle)
                    .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
                }
                if #available(iOS 26, *) {
                    Button(action: {
                        onTabCallback(TabWidgetType.settings)
                    }, label: {
                        Image("settings_tab")
                    })
                    .frame(width: 70, height: 70)
                    .contentShape(.circle)
                    .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
                }
            }
        }
    }
}

#Preview {
    HomeTab { _ in
        
    }
}
