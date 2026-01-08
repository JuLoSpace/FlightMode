//
//  FlyTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//


import SwiftUI


struct FlyTab: View {
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Time remaining")
                        .font(.custom("Montserrat", size: 12))
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Your speed")
                        .font(.custom("Montserrat", size: 14))
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Distance remaining")
                        .font(.custom("Montserrat", size: 12))
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                HStack {
                    Text("58 MIN")
                        .font(.custom("Wattauchimma", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("836 KM/H")
                        .font(.custom("Wattauchimma", size: 26))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("3,808 KM")
                        .font(.custom("Wattauchimma", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    FlyTab()
}
