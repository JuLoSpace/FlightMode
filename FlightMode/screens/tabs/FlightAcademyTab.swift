//
//  FlightAcademyTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

struct FlightAcademyTab : View {
    
    @EnvironmentObject var airportsService: AirportsService
    
    @State var totalFlights: Int?
    @State var totalDistance: Int?
    @State var successRate: Int?
    @State var totalXP: Double?
    @State var currentStreak: Double?
    @State var longestStreak: Double?
    
    func computeStatistics(_ historyFlights: [Flight]?) {
        
        guard let flights = historyFlights else { return }
        
        totalFlights = flights.count
        
        var successCount: Int = 0
        var distance: Double = 0
        
        flights.forEach { flight in
            if flight.flightProcess.flightType == .success {
                successCount += 1
            }
            distance += MetricsService.distance(a: flight.airportDeparture, b: flight.airportDestination)
        }
        
        totalDistance = Int(distance / 1000)
        successRate = Int(100 * successCount / flights.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical) {
                    HStack {
                        Text("FLIGHT ACADEMY")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    .frame(width: geometry.size.width, alignment: .topLeading)
                    if #available(iOS 26, *) {
                        VStack {
                            HStack(alignment: .center) {
                                Image("ace")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(20))
                                    .padding(.all, 5)
                                    .background(Color(hex: "FFAE17"))
                                    .clipShape(.circle)
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center) {
                                        Text("Ace Pilot")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                        +
                                        Text(" → ")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white.opacity(0.25))
                                        +
                                        Text("Legend")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white.opacity(0.25))
                                        Spacer()
                                        Text("278")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
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
                            .glassEffect()
                        }
                        .padding(.horizontal, 20)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Flight")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.5))
                                Spacer()
                                if let totalFlights = totalFlights {
                                    Text(String(totalFlights))
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                } else {
                                    Text("No flights")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width * 0.44, height: 150, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading) {
                                Text("Success Rate")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.5))
                                Spacer()
                                if let successRate = successRate {
                                    Text("\(successRate)%")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                } else {
                                    Text("No rate")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width * 0.44, height: 150, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total distance")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.5))
                                Spacer()
                                if let totalDistance = totalDistance {
                                    Text("\(totalDistance) km")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                } else {
                                    Text("No flights")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width * 0.44, height: 150, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading) {
                                Text("Total XP")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.5))
                                Spacer()
                                if let totalXP = totalXP {
                                    Text(String(totalXP))
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                } else {
                                    Text("0")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width * 0.44, height: 150, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Current Streak")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.5))
                                Spacer()
                                if let currentStreak = currentStreak {
                                    Text(String(currentStreak))
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                } else {
                                    Text("0")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width * 0.44, height: 150, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading) {
                                Text("Longest Streak")
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white.opacity(0.5))
                                Spacer()
                                if let longestStreak = longestStreak {
                                    Text(String(longestStreak))
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                } else {
                                    Text("0")
                                        .font(.custom("Montserrat", size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width * 0.44, height: 150, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .onAppear {
            computeStatistics(airportsService.historyFlights)
        }
    }
}

#Preview {
    FlightAcademyTab()
}
