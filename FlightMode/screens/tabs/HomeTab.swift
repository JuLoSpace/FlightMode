//
//  HomeTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

struct HomeTab : View {
    
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if #available(iOS 26, *) {
                    Button(action: {
    //                    onTabCallback()
                    }, label: {
                        Text("Start flight")
                            .font(.custom("Montserrat", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(height: 60)
                    })
                    .padding(.horizontal, 20)
                    .frame(width: max(geometry.size.width - 40, 0))
                    .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
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
                        .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
                    }
                    if #available(iOS 26, *) {
                        Button(action: {
                            onTabCallback(TabWidgetType.history)
                        }, label: {
                            Image("history_tab")
                        })
                        .frame(width: 70, height: 70)
                        .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
                    }
                    if #available(iOS 26, *) {
                        Button(action: {
                            onTabCallback(TabWidgetType.settings)
                        }, label: {
                            Image("settings_tab")
                        })
                        .frame(width: 70, height: 70)
                        .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
                    }
                }
            }
            .frame(width: geometry.size.width)
        }
    }
}

#Preview {
    HomeTab { _ in
        
    }
}
