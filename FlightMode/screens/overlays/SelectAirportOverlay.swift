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
//                        if let location = locationService.location {
//                            if let time = activeId {
//                                airportsService.getShowableAirports(lat: location.latitude, lon: location.longitude, time: Double(time) * 600.0)
//                            }
//                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .frame(width: geometry.size.width - 40, height: 80)
                .glassEffect()
                .padding(.horizontal, 20)
            }
        }
    }
}


#Preview {
    SelectAirportOverlay()
}
