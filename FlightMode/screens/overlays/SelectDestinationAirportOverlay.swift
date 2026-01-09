//
//  SelectAirportOverlay.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//


import SwiftUI
import CoreLocation

struct SelectDestinationAirportOverlay: View {
    
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
    
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            let backButton = Button(action: {
                onTabCallback(.home)
            }, label: {
                Image(systemName: "chevron.backward")
                    .frame(width: 40, height: 40)
            })
            if #available(iOS 26, *) {
                backButton
                    .buttonBorderShape(.circle)
                    .buttonStyle(.glass)
                    .padding(.leading, 10)
            }
            Spacer()
            if #available(iOS 26, *) {
                VStack {
                    GeometryReader { geometry in
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(1..<31, id: \.self) { m in
                                    let hours = (m * 10) / 60
                                    let minutes = (m * 10) % 60
                                    let time: String = hours == 0 ? "\(minutes)m" : (minutes == 0 ? "\(hours)h" : "\(hours)h \(minutes)m")
                                    VStack(spacing: 0) {
                                        Text(time)
                                            .font(.custom("Montserrat", size: m == activeId ? 24 : 14))
                                            .fontWeight(m == activeId ? .bold : .regular)
                                            .frame(width: 100)
                                            .foregroundStyle(m == activeId ? .white : .white.opacity(0.25))
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    activeId = m
                                                }
                                            }
                                            .frame(maxHeight: .infinity)
                                            .padding(.top, 10)
                                            .frame(alignment: .center)
                                        Color.white
                                            .frame(width: 1, height: 10)
                                    }
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
                        .glassEffect()
                        .padding(.horizontal, 20)
                        .scrollIndicators(.hidden)
                    }
                    .frame(height: 80)
                    .padding(.bottom, 20)
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
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 5)
                                        Spacer()
                                        Text(time)
                                            .font(.custom("Montserrat", size: 16))
                                            .multilineTextAlignment(.center)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 10)
                                            .frame(width: 60, height: 60)
                                            .background(Color(hex: "3F3F3F"))
                                            .clipShape(.circle)
                                    }
                                    .padding(.top, 20)
                                    .padding(.bottom, 5)
//                                    .padding(.horizontal, 5)
                                    .frame(width: 70)
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
                    .frame(height: 80)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            updateAirports()
        }
    }
}


#Preview {
    SelectDestinationAirportOverlay { _ in
        
    }
}
