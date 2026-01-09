//
//  FlyTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//


import SwiftUI


struct FlyTab: View {
    
    @EnvironmentObject var airportsService: AirportsService
    
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
                if let flight = airportsService.currentFlight {
                    FlyTabInfo(flight: flight)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
        }
    }
}

struct FlyTabInfo: View {
    
    @ObservedObject var flight: Flight
    
    var body: some View {
        HStack {
            Text(TimeTranslate.secToString(flight.remainingTime))
                .font(.custom("Wattauchimma", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(Int(flight.currentSpeed)) M/S")
                .font(.custom("Wattauchimma", size: 26))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("\(Int(flight.remainingDistance / 1000)) KM")
                .font(.custom("Wattauchimma", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    FlyTab()
}
