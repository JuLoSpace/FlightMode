//
//  HomeScreen.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//

import SwiftUI

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


struct HomeScreen : View {
    
    @State var tabWidgetType: TabWidgetType = TabWidgetType.home
    
    @State var tabWidgets: [TabWidgetType: AnyView] = [
        .flightAcademy: AnyView(FlightAcademyTab()),
        .history: AnyView(HistoryTab()),
        .settings: AnyView(SettingsTab()),
    ]
    
    @State var currentTab: TabWidgetType = TabWidgetType.home
    @State var currentTabShape: AnyShape = AnyShape(
        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
    )
    
    @EnvironmentObject var airportsService: AirportsService
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var settingsService: SettingsService
    
    @State var overlayContent: AnyView?
    @State var overlayScreen: AnyView? = AnyView(HomeOverlay())
    
    @State var tabHeight: Double?
    @State var track: Bool = true
    
    func openWidget(tabWidgetType: TabWidgetType) {
        switch tabWidgetType {
        case .home:
            currentTabShape = AnyShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
            )
            overlayScreen = AnyView(HomeOverlay())
            overlayContent = nil
        case .flightAcademy:
            currentTabShape = AnyShape(
                CustomTab()
            )
            overlayScreen = AnyView(HomeOverlay())
            overlayContent = nil
        case .history:
            currentTabShape = AnyShape(
                CustomTab()
            )
            overlayScreen = AnyView(HomeOverlay())
            overlayContent = nil
        case .settings:
            currentTabShape = AnyShape(
                CustomTab()
            )
            overlayScreen = AnyView(HomeOverlay())
            overlayContent = nil
        case .flight(let flightWidgetType):
            switch flightWidgetType {
            case .setLocation:
                currentTabShape = AnyShape(
                    CustomTab()
                )
                overlayScreen = nil
                overlayContent = nil
            case .selectAirport:
                currentTabShape = AnyShape(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
                )
                overlayContent = AnyView(SelectDestinationAirportOverlay(onTabCallback: { type in
                    openWidget(tabWidgetType: type)
                }))
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
                overlayContent = nil
            case .ticket:
                currentTabShape = AnyShape(
                    CustomTab()
                )
                overlayContent = nil
//                overlayScreen = AnyView(TicketScreen())
            case .fly(let flyWidgetType):
                switch flyWidgetType {
                case .map:
                    // remake in next updates
                    currentTabShape = AnyShape(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
                    )
                    overlayContent = AnyView(FlyOverlay(track: $track, onTabCallback: { type in
                        openWidget(tabWidgetType: type)
                    }))
                    overlayScreen = nil
                case .pause:
                    currentTabShape = AnyShape(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
                    )
                    overlayScreen = nil
                case .cockpit:
                    overlayScreen = nil
                case .music:
                    overlayScreen = nil
                }
            case .destination:
                overlayScreen = AnyView(DestinationOverlay(onTabCallback: { type in
                    openWidget(tabWidgetType: type)
                }))
                overlayContent = nil
            }
        case .avatar:
            overlayScreen = AnyView(ChooseAvatarScreen(onTabCallback: { type in
                openWidget(tabWidgetType: type)
            }))
        }
        if currentTab == TabWidgetType.flight(.fly(.map)) &&
            (tabWidgetType == TabWidgetType.flight(.fly(.map)) || tabWidgetType == TabWidgetType.flight(.fly(.cockpit)) || tabWidgetType == TabWidgetType.flight(.fly(.pause)) || tabWidgetType == TabWidgetType.flight(.fly(.music))) {
            // code
        } else {
            currentTab = tabWidgetType
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                MapScreen(onTabCallback: { type in
                    openWidget(tabWidgetType: type)
                }, track: $track)
                VStack {
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                .background(LinearGradient(colors: [
                    .black,
                    .clear
                ], startPoint: .top, endPoint: .bottom))
                VStack {
                    if let _overlayContent = overlayContent {
                        _overlayContent
                        .frame(maxWidth: geometry.size.width)
                        .padding(.bottom, 20)
                    }
                    ZStack(alignment: .top) {
                        let tabView = tabWidgets[currentTab]
                            .padding(.vertical, 30)
                            .frame(width: geometry.size.width)
                            .background(Color(hex: "2F2F2F").opacity(0.75))
                            .clipShape(currentTabShape)
                        if ![TabWidgetType.home, TabWidgetType.flight(.selectAirport), TabWidgetType.flight(.fly(.map))].contains(currentTab) {
                            tabView
                                .frame(maxHeight: geometry.size.height * 0.5 + geometry.safeAreaInsets.bottom)
                                .ignoresSafeArea(.keyboard)
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
                .id(currentTab)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: currentTab)
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
                tabWidgets[.flight(.setLocation)] = AnyView(SelectDepartureAirportTab(onTabCallback: { type in
                    openWidget(tabWidgetType: type)
                }))
                airportsService.onFlightEndCallback = {
                    openWidget(tabWidgetType: .flight(.destination))
                }
                
                if settingsService.name == nil {
                    openWidget(tabWidgetType: .avatar)
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
