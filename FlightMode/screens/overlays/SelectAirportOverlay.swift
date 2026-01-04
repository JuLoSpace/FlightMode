//
//  SelectAirportOverlay.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//


import SwiftUI
import CoreLocation

struct SelectAirportOverlay: View {
    
    @State private var activeId: Int? = 1
    
    @EnvironmentObject var airportsService: AirportsService
    @EnvironmentObject var locationService: LocationService
    
    func updateAirports() {
        if let location = locationService.location {
            if let time = activeId {
                airportsService.getShowableAirports(lat: location.latitude, lon: location.longitude, time: Double(time) * 600.0)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            if #available(iOS 26, *) {
                VStack {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(1..<31, id: \.self) { m in
                                let hours = (m * 10) / 60
                                let minutes = (m * 10) % 60
                                let time: String = hours == 0 ? "\(minutes)m" : (minutes == 0 ? "\(hours)h" : "\(hours)h \(minutes)m")
                                Text(time)
                                    .font(.custom("Montserrat", size: m == activeId ? 24 : 16))
                                    .frame(width: 100)
                                    .foregroundStyle(m == activeId ? .white : .white.opacity(0.25))
                                    .id(m)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, geometry.size.width / 2 - 70)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $activeId, anchor: .center)
                    .sensoryFeedback(.impact(weight: .medium), trigger: activeId)
                    .onChange(of: activeId) { oldValue, newValue in
                        updateAirports()
                    }
                    .frame(width: geometry.size.width - 40, height: 80)
                    .glassEffect()
                    .padding(.horizontal, 20)
                    .scrollIndicators(.hidden)
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(airportsService.showableAirports, id: \.self) { point in
                                if let cityName = point.airport.city {
                                    let m: Int = Int(point.time) / 60
                                    let hours: Int = m / 60
                                    let minutes: Int = m % 60
                                    let time: String = hours == 0 ? "\(minutes)m" : (minutes == 0 ? "\(hours)h" : "\(hours)h \(minutes)m")
                                    VStack(spacing: 0) {
                                        Text(cityName)
                                            .font(.custom("Monserrat", size: 12))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text(time)
                                            .font(.custom("Monserrat", size: 16))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .frame(width: 70, height: 50)
                                            .background(Color(hex: "3F3F3F"))
                                            .clipShape(.circle)
                                    }
                                    .padding(.top, 20)
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 5)
                                    .frame(width: 80, height: 100)
                                    .glassEffect(.regular.tint(point.airport == airportsService.destinationAirport ? Color(hex: "FFAE17") : .clear))
                                    .padding(.horizontal, 5)
                                    .onTapGesture {
                                        airportsService.selectDestinationAirport(point.airport)
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(width: geometry.size.width, height: 100)
                }
            }
        }
        .onAppear {
            updateAirports()
        }
    }
}


#Preview {
    SelectAirportOverlay()
}
