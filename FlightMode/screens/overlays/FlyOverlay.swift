//
//  FlyOverlay.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//

import SwiftUI
import CoreLocation

enum FlyStyle {
    case map
    case cockpit
}

struct FlyTab: View {
    
    @ObservedObject var flight: Flight
    
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
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
        }
    }
}

struct ButtonsView: View {
    
    var onTabCallback: (TabWidgetType) -> ()
    
    @ObservedObject var flight: Flight
    @ObservedObject var flightProcess: FlightProcess
    @Binding var track: Bool
    
    @Binding var flyTab: FlyWidgetType
    
    var body: some View {
        HStack(alignment: .top) {
            let pauseButton = Button(action: {
                if flightProcess.flightType == .pause {
                    flight.run()
                    onTabCallback(TabWidgetType.flight(.fly(.map)))
                    flyTab = FlyWidgetType.map
                } else if flightProcess.flightType == .process {
                    flight.pause()
                    onTabCallback(TabWidgetType.flight(.fly(.pause)))
                    flyTab = FlyWidgetType.pause
                }
            }, label: {
                if flightProcess.flightType == .pause {
                    Image(systemName: "play.fill")
                        .frame(width: 50, height: 50)
                } else if flightProcess.flightType == .process {
                    Image("pause")
                        .frame(width: 50, height: 50)
                }
            })
            if #available(iOS 26, *) {
                pauseButton
                    .buttonBorderShape(.circle)
                    .buttonStyle(.glass)
            }
            Spacer()
            HStack {
                let musicButton = Button(action: {
                    onTabCallback(TabWidgetType.flight(.fly(.music)))
                }, label: {
                    Image("music")
                        .frame(width: 50, height: 50)
                })
                if #available(iOS 26, *) {
                    musicButton
                        .buttonBorderShape(.circle)
                        .buttonStyle(.glass)
                }
                
                let locationButton = Button(action: {
                    track = true
                    if let pos = flightProcess.position {
                        if let mapCallback = MapService.mapMoveCallback {
                            mapCallback(pos.latitude, pos.longitude, 0.2, .zero, MetricsService.heading(lat1: flight.airportDeparture.lat, lon1: flight.airportDeparture.lon, lat2: flight.airportDestination.lat, lon2: flight.airportDestination.lon))
                        }
                    }
                }, label: {
                    Image("location")
                        .frame(width: 50, height: 50)
                })
                if #available(iOS 26, *) {
                    locationButton
                        .buttonBorderShape(.circle)
                        .buttonStyle(.glass)
                }
            }
        }
        .onChange(of: flightProcess.position) { _, newValue in
            if track {
                if let pos = newValue {
                    if let mapCallback = MapService.mapMoveCallback {
                        mapCallback(pos.latitude, pos.longitude, 0.2, .zero, MetricsService.heading(lat1: flight.airportDeparture.lat, lon1: flight.airportDeparture.lon, lat2: flight.airportDestination.lat, lon2: flight.airportDestination.lon))
                    }
                }
            }
        }.onChange(of: flightProcess.flightType) { _, newValue in
            if [FlightType.success, FlightType.cancelled].contains(newValue) {
                onTabCallback(TabWidgetType.flight(.destination))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlyOverlay: View {
    
    @State var selectedFlyStyle: FlyStyle = FlyStyle.map
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var airportsService: AirportsService
    @Binding var track: Bool
    @State var flyTab: FlyWidgetType = .map
    
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        ZStack {
            
            VStack {
                if let flight = airportsService.currentFlight {
                    ButtonsView(onTabCallback: onTabCallback, flight: flight, flightProcess: flight.flightProcess, track: $track, flyTab: $flyTab)
                }
                if flyTab == .pause {
                    Color.clear
                        .background(LinearGradient(colors: [
                            Color.clear,
                            Color.black
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if selectedFlyStyle == .map && flyTab != .pause {
                    Spacer()
                    let selectFlyStyleWidth: Double = 280
                    let selectFlyStyle = ZStack {
                        if #available(iOS 26, *) {
                            Color.clear
                            .frame(width: selectFlyStyleWidth / 2 - 5, height: 50)
                            .glassEffect(.regular.tint(Color(hex: "FFAE17")))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: selectedFlyStyle == .map ? 5 : selectFlyStyleWidth / 2 + 5)
                            .animation(Animation.easeInOut(duration: 0.3), value: selectedFlyStyle)
                        }
                        HStack(spacing: 2) {
                            Image("mapIcon")
                                .opacity(selectedFlyStyle == .map ? 1.0 : 0.5)
                            Text("Map")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(selectedFlyStyle == .map ? .white : .white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.trailing, selectFlyStyleWidth / 2)
                        .onTapGesture {
                            selectedFlyStyle = .map
                        }
                        HStack(spacing: 2) {
                            Image("cockpitIcon")
                                .opacity(selectedFlyStyle == .cockpit ? 1.0 : 0.5)
                            Text("Cockpit")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(selectedFlyStyle == .cockpit ? .white : .white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, selectFlyStyleWidth / 2)
                        .onTapGesture {
        //                    selectedFlyStyle = .cockpit
                        }
                    }
                    .frame(width: selectFlyStyleWidth, height: 60)
                    if #available(iOS 26, *) {
                        selectFlyStyle
                            .glassEffect()
                    }
                    if let flight = airportsService.currentFlight {
                        FlyTab(flight: flight)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(Color(hex: "2F2F2F").opacity(0.75))
                            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32)))
                    }
                }
            }
            if flyTab == .pause {
                if let flight = airportsService.currentFlight {
                    FlyTab(flight: flight)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    @State var track = true
    FlyOverlay(track: $track, onTabCallback: { _ in })
}
