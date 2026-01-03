//
//  SelectAirport.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import SwiftUI

struct SelectAirportTab: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if #available(iOS 26, *) {
                    Button(action: {
    //                    onTabCallback()
                    }, label: {
                        Text("Book my flight")
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
        }
    }
}
