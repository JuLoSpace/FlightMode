//
//  HomeScreen.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct CustomTab : Shape {
    
    var cornerRadius: CGFloat = 32.0
    var centerRadius: CGFloat = 30.0
    var offset: CGFloat = 40.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width / 2 - offset, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.width / 2 - offset / 2, y: centerRadius / 2), control: CGPoint(x: rect.width / 2 - offset * 0.8, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.width / 2 + offset / 2, y: centerRadius / 2), control: CGPoint(x: rect.width / 2, y: centerRadius))
        path.addQuadCurve(to: CGPoint(x: rect.width / 2 + offset, y: 0), control: CGPoint(x: rect.width / 2 + offset * 0.8, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct HomeScreen : View {
    
    @State var tabWidgetType: TabWidgetType = TabWidgetType.home
    
    @State var tabWidgets: [TabWidgetType: AnyView] = [
        .flightAcademy: AnyView(FlightAcademyTab()),
        .history: AnyView(HistoryTab()),
        .settings: AnyView(SettingsTab()),
        .flight(.fly): AnyView(FlyTab())
    ]
    
    @State var currentTab: TabWidgetType = TabWidgetType.home
    @State var currentTabShape: AnyShape = AnyShape(
        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
    )
    
//    @State var tabHeight: Double = 180
    
    @EnvironmentObject var airportsService: AirportsService
    @EnvironmentObject var locationService: LocationService
    
    @State var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
    )
    
    @State var overlayContent: AnyView?
    @State var overlayScreen: AnyView?
    
    func openWidget(tabWidgetType: TabWidgetType) {
        currentTab = tabWidgetType
        switch tabWidgetType {
        case .home:
            currentTabShape = AnyShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
            )
            overlayScreen = nil
        case .flightAcademy:
            currentTabShape = AnyShape(
                CustomTab()
            )
            overlayScreen = nil
        case .history:
            currentTabShape = AnyShape(
                CustomTab()
            )
            overlayScreen = nil
        case .settings:
            currentTabShape = AnyShape(
                CustomTab()
            )
            overlayScreen = nil
        case .flight(let flightWidgetType):
            switch flightWidgetType {
            case .setLocation:
                currentTabShape = AnyShape(
                    CustomTab()
                )
                overlayScreen = nil
            case .selectAirport:
                currentTabShape = AnyShape(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
                )
                overlayContent = AnyView(SelectDestinationAirportOverlay())
                overlayScreen = nil
            case .selectSeat:
                currentTabShape = AnyShape(
                    CustomTab()
                )
                overlayScreen = AnyView(SeatSelectorScreen(
                    onTabCallback: { type in
                        openWidget(tabWidgetType: type)
                    }
                ))
            case .ticket:
                currentTabShape = AnyShape(
                    CustomTab()
                )
                overlayContent = nil
                overlayScreen = AnyView(TicketScreen())
            case .fly:
                currentTabShape = AnyShape(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
                )
                overlayContent = AnyView(FlyOverlay())
                overlayScreen = nil
            }
        }
    }
    
    func animateMapTo(lat: Double, lon: Double, delta: Double) {
        withAnimation(.easeInOut(duration: 2.0)) {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
                )
            )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Map(position: $position) {
                    if let pos = locationService.location {
                        Annotation("POSITION", coordinate: CLLocationCoordinate2D(latitude: pos.latitude, longitude: pos.longitude)) {
                            Color.white.opacity(0.15)
                                .frame(width: 30, height: 30)
                                .clipShape(.circle)
                                .overlay {
                                    Color.white
                                        .frame(width: 20, height: 20)
                                        .clipShape(.circle)
                                        .overlay {
                                            Color(hex: "FFAE17")
                                                .frame(width: 10, height: 10)
                                                .clipShape(.circle)
                                        }
                                }
                        }
                        .annotationTitles(.hidden)
                    }
                    if let departureAirport = airportsService.departureAirport {
                        Annotation("test", coordinate: CLLocationCoordinate2D(latitude: departureAirport.lat, longitude: departureAirport.lon)) {
                            Text(departureAirport.iata ?? departureAirport.icao)
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(hex: "FFAE17"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 1))
                                        .foregroundStyle(.white)
                                }
                        }
                        .annotationTitles(.hidden)
                        if let time = airportsService.selectedTime {
                            MapCircle(center: CLLocationCoordinate2D(latitude: departureAirport.lat, longitude: departureAirport.lon), radius: time * airportsService.airplaneAverageSpeed)
                                .foregroundStyle(.white.opacity(0.15))
                                .stroke(.white.opacity(0.25), lineWidth: 1)
                                .mapOverlayLevel(level: .aboveLabels)
                        }
                        if let destinationAirport = airportsService.destinationAirport {
                            MapPolyline(coordinates: [
                                CLLocationCoordinate2D(latitude: departureAirport.lat, longitude: departureAirport.lon),
                                CLLocationCoordinate2D(latitude: destinationAirport.lat, longitude: destinationAirport.lon)
                            ])
                            .stroke(.white, lineWidth: 2,)
                        }
                    }
                    ForEach(airportsService.showableAirports, id: \.self) { point in
                        Annotation(point.airport.name ?? "airport", coordinate: CLLocationCoordinate2D(latitude: point.airport.lat, longitude: point.airport.lon)) {
                            Text((point.airport.iata != nil ? point.airport.iata : point.airport.icao) ?? point.airport.icao)
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(hex: point.airport == airportsService.destinationAirport ? "544323" : "4D4D4D"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 2))
                                        .foregroundStyle(Color(hex: point.airport == airportsService.destinationAirport ? "FFAE17" : "FFFFFF"))
                                }
                                .onTapGesture(perform: {
                                    airportsService.selectDestinationAirport(point.airport)
                                })
                        }
                        .annotationTitles(.hidden)
                    }
                }
                .preferredColorScheme(.dark)
                .mapStyle(.standard(elevation: .realistic, emphasis: .automatic))
                VStack {
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                .background(LinearGradient(colors: [
                    .black,
                    .clear
                ], startPoint: .top, endPoint: .bottom))
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Good afternoon,")
                                .font(.custom("Montserrat", size: 24))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.5))
                                .lineLimit(1)
                            Text("USER")
                                .font(.custom("Montserrat", size: 36))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            if #available(iOS 26, *) {
                                Text("🔥 5 Days")
                                    .font(.custom("Montserrat", size: 14))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 20)
                                    .glassEffect()
                            }
                            if #available(iOS 26, *) {
                                HStack(alignment: .center) {
                                    Image("ace")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .rotationEffect(.degrees(20))
                                        .padding(.all, 5)
                                        .background(Color(hex: "FFAE17"))
                                        .clipShape(.circle)
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("Legend")
                                                .font(.custom("Montserrat", size: 12))
                                                .fontWeight(.bold)
                                                .foregroundStyle(.white)
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
                                .frame(width: geometry.size.width * 0.4)
                                .glassEffect()
                            }
                            if #available(iOS 26, *) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Daily challenge")
                                        .font(.custom("Montserrat", size: 14))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "FFAE17"))
                                    HStack {
                                        Text("Fly 60 min")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text("0 / 1")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                    .padding(.top, 6)
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
                                        .padding(.bottom, 8)
                                    HStack {
                                        Text("Award: ")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        +
                                        Text("+200 miles")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .frame(width: geometry.size.width * 0.4)
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                VStack {
                    if let _overlayContent = overlayContent {
                        _overlayContent
                            
                            .frame(maxWidth: geometry.size.width) // TODO: flexible size
                        .padding(.bottom, 20)
                    }
                    ZStack(alignment: .top) {
                        let tabView = tabWidgets[currentTab]
                            .padding(.vertical, 30)
                            .frame(width: geometry.size.width)
                            .background(Color(hex: "2F2F2F").opacity(0.75))
                            .clipShape(currentTabShape)
                        if ![TabWidgetType.home, TabWidgetType.flight(.selectAirport), TabWidgetType.flight(.fly)].contains(currentTab) {
                            tabView
                                .frame(maxHeight: geometry.size.height * 0.5)
                            if #available(iOS 26, *) {
                                Button(action: {
                                    openWidget(tabWidgetType: .home)
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 24))
                                        .frame(width: 34, height: 34)
                                })
                                .buttonBorderShape(.circle)
                                .contentShape(.circle)
                                .buttonStyle(.glass)
                                .offset(y: -34)
                            }
                        } else {
                            tabView
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
                if let overlay = overlayScreen {
                    overlay
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .onAppear {
                tabWidgets[.home] = AnyView(
                    HomeTab(onTabCallback: { tabType in
                        openWidget(tabWidgetType: tabType)
                    })
                )
                tabWidgets[.flight(.selectAirport)] = AnyView(SelectAirportTab(onTabCallback: { type in
                    openWidget(tabWidgetType: type)
                }))
                locationService.requestLocation()
                locationService.locationCallback = {
                    if let pos = locationService.location {
                        animateMapTo(lat: pos.latitude, lon: pos.longitude, delta: 2.0)
                    }
                }
                airportsService.mapMoveCallback = { lat, lon, delta in
                    animateMapTo(lat: lat, lon: lon, delta: delta)
                }
            }
        }
//        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    HomeScreen()
}
