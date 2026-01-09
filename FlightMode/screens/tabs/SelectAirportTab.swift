//
//  SelectAirport.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import SwiftUI

struct SelectAirportTab: View {
    
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            if #available(iOS 26, *) {
                Button(action: {
                    onTabCallback(TabWidgetType.flight(.selectSeat))
                }, label: {
                    Text("Book my flight")
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
