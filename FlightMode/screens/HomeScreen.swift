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
    
    @State var tabHeight: Double = 180
    
    func openWidget(tabWidgetType: TabWidgetType) {
        currentTab = tabWidgetType
        switch tabWidgetType {
        case .home:
            currentTabShape = AnyShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32, topTrailing: 32))
            )
        case .flightAcademy:
            currentTabShape = AnyShape(
                CustomTab()
            )
        case .history:
            currentTabShape = AnyShape(
                CustomTab()
            )
        case .settings:
            currentTabShape = AnyShape(
                CustomTab()
            )
        case .flight(let flightWidgetType):
            currentTabShape = AnyShape(
                CustomTab()
            )
        }
        
        if currentTab == .home {
            withAnimation(.linear) {
                tabHeight = 180
            }
        } else {
            withAnimation(.easeIn(duration: 0.2)) {
                tabHeight = 500
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Map() {
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
                    ZStack(alignment: .top) {
                        tabWidgets[currentTab]
                            .padding(.vertical, 30)
                            .frame(width: geometry.size.width, height: tabHeight)
                            .background(Color(hex: "2F2F2F").opacity(0.75))
                            .clipShape(currentTabShape)
                        if currentTab != TabWidgetType.home {
                            if #available(iOS 26, *) {
                                Button(action: {
                                    openWidget(tabWidgetType: .home)
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 24))
                                        .frame(width: 34, height: 34)
                                })
                                .buttonBorderShape(.circle)
                                .buttonStyle(.glass)
                                .offset(y: -34)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            }
            .onAppear {
                tabWidgets[.home] = AnyView(
                    HomeTab(onTabCallback: { tabType in
                        openWidget(tabWidgetType: tabType)
                    })
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    HomeScreen()
}
