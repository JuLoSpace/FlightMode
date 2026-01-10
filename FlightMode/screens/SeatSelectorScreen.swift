//
//  SeatSelectorScreen.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 04.01.2026.
//

import SwiftUI


struct Seat: View {
    
    let width: Double = 40.0
    let height: Double = 40.0
    
    let callback: () -> ()
    
    var isActive: Bool
    
    var body: some View {
        ZStack {
            isActive ?
            Color(hex: "FFAE17")
                .opacity(0.5)
                .frame(width: width, height: height - 4)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            :
            Color(hex: "2F2F2F")
                .frame(width: width, height: height - 4)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack(spacing: 0) {
                Color(hex: isActive ? "FFAE17" : "474747")
                    .frame(width: 8, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Spacer()
                VStack {
                    Spacer()
                    Color(hex: isActive ? "FFAE17" : "6E6E6E")
                        .frame(width: 20, height: 8)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                Spacer()
                Color(hex: isActive ? "FFAE17" : "474747")
                    .frame(width: 8, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(width: width, height: height)
        .onTapGesture {
            callback()
        }
    }
}

struct SeatPreferenceKey: PreferenceKey {
    
    static var defaultValue: [Int: CGRect] = [:]
    
    static func reduce(value: inout [Int : CGRect], nextValue: () -> [Int : CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct WidgetShape: Shape {
    
    let triangleSize: Double = 10.0
    let cornerRadius: Double = 16.0
    var offsetX: Double
    var isMirror: Bool
    
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if !isMirror {
            path.move(to: CGPoint(x: 0, y: triangleSize))
            path.addArc(center: CGPoint(x: cornerRadius, y: triangleSize + cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
            path.addLine(to: CGPoint(x: rect.width / 2 - triangleSize - offsetX, y: triangleSize))
            path.addLine(to: CGPoint(x: rect.width / 2 - offsetX, y: 0))
            path.addLine(to: CGPoint(x: rect.width / 2 + triangleSize - offsetX, y: triangleSize))
            path.addLine(to: CGPoint(x: rect.width, y: triangleSize))
            path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: triangleSize + cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - triangleSize))
            path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius - triangleSize), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: rect.width / 2 - triangleSize - offsetX, y: rect.height - triangleSize))
            path.addLine(to: CGPoint(x: rect.width / 2 - offsetX, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width / 2 + triangleSize - offsetX, y: rect.height - triangleSize))
            path.addLine(to: CGPoint(x: 0, y: rect.height - triangleSize))
            path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius - triangleSize), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        }
        
        return path
    }
}

struct SeatSelectorScreen: View {
    
    var onTabCallback: (TabWidgetType) -> ()

    @State var selectedSeat: Int?
    @State var seatFrames: [Int: CGRect] = [:]
    
    @State var selectedMission: Mission?
    
    @EnvironmentObject var user: UserModel
    @EnvironmentObject var airportsService: AirportsService
    
    @State var letsGoOffset: Double = 50
    
    func onSeatTap(_ index: Int) {
        if selectedSeat == index {
            selectedSeat = nil
        } else {
            selectedSeat = index
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    if #available(iOS 26, *) {
                        Button(action: {
                            onTabCallback(TabWidgetType.flight(.selectAirport))
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .buttonBorderShape(.circle)
                        .buttonStyle(GlassButtonStyle())
                        .padding(.horizontal, 20)
                    } else {
                        Button(action: {
                            onTabCallback(TabWidgetType.flight(.selectAirport))
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.all, 6)
                        })
                        .foregroundStyle(.white)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 20)
                    }
                    VStack {
                        VStack {
                            Text("CHOOSE YOUR SEAT IN COCKPIT ")
                                .font(.custom("Wattauchimma", size: 40))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            +
                            Text("BOEING 737")
                                .font(.custom("Wattauchimma", size: 40))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "FFAE17"))
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                        Image("airplane")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.65, alignment: .top)
                            .clipped()
                            .scaleEffect(1.7)
                    }
                }
                ZStack(alignment: .bottom) {
                    VStack {
                        VStack(alignment: .center, spacing: 20) {
                            HStack(spacing: 20) {
                                Seat(callback: {
                                    onSeatTap(0)
                                }, isActive: selectedSeat == 0)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: SeatPreferenceKey.self, value: [0: geo.frame(in: .named("seatSpace"))])
                                    }
                                )
                                Seat(callback: {
                                    onSeatTap(1)
                                }, isActive: selectedSeat == 1)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: SeatPreferenceKey.self, value: [1: geo.frame(in: .named("seatSpace"))])
                                    }
                                )
                            }
                            .zIndex(1)
                            HStack {
                                VStack(spacing: 10) {
                                    ForEach(0..<6, id: \.self) { i in
                                        HStack(spacing: 20) {
                                            Seat(callback: {
                                                onSeatTap(i * 2 + 2)
                                            }, isActive: selectedSeat == i * 2 + 2)
                                            .background(
                                                GeometryReader { geo in
                                                    Color.clear
                                                        .preference(key: SeatPreferenceKey.self, value: [i * 2 + 2: geo.frame(in: .named("seatSpace"))])
                                                }
                                            )
                                            Seat(callback: {
                                                onSeatTap(i * 2 + 3)
                                            }, isActive: selectedSeat == i * 2 + 3)
                                            .background(
                                                GeometryReader { geo in
                                                    Color.clear
                                                        .preference(key: SeatPreferenceKey.self, value: [i * 2 + 3: geo.frame(in: .named("seatSpace"))])
                                                }
                                            )
                                        }
                                    }
                                }
                                Spacer()
                                VStack(spacing: 10) {
                                    ForEach(0..<6, id: \.self) { i in
                                        HStack(spacing: 20) {
                                            Seat(callback: {
                                                onSeatTap(i * 2 + 14)
                                            }, isActive: selectedSeat == i * 2 + 14)
                                            .background(
                                                GeometryReader { geo in
                                                    Color.clear
                                                        .preference(key: SeatPreferenceKey.self, value: [i * 2 + 14: geo.frame(in: .named("seatSpace"))])
                                                }
                                            )
                                            Seat(callback: {
                                                onSeatTap(i * 2 + 15)
                                            }, isActive: selectedSeat == i * 2 + 15)
                                            .background(
                                                GeometryReader { geo in
                                                    Color.clear
                                                        .preference(key: SeatPreferenceKey.self, value: [i * 2 + 15: geo.frame(in: .named("seatSpace"))])
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.6, alignment: .bottom)
                        .padding(.bottom, 10)
                        if let _ = selectedSeat, let _ = selectedMission {
                            if #available(iOS 26, *) {
                                let btnSize: Double = 50.0
                                GeometryReader { buttonGeometry in
                                    ZStack(alignment: .center) {
                                        VStack {
                                            Image("letsGo_2")
                                                .frame(width: btnSize, height: btnSize)
                                        }
                                        .frame(width: buttonGeometry.size.width, alignment: .trailing)
                                        VStack {
                                            Text("Let's go")
                                                .font(.custom("Montserrat", size: 20))
                                                .fontWeight(.bold)
                                                .foregroundStyle(.white)
                                        }
                                        .frame(width: buttonGeometry.size.width, alignment: .center)
                                        ZStack(alignment: .trailing) {
                                            Color(hex: "FFAE17")
                                                .frame(width: letsGoOffset, alignment: .leading)
                                                .cornerRadius(btnSize / 2)
                                            Image("letsGo_1")
                                                .frame(width: btnSize, height: btnSize)
                                                .glassEffect(.clear.tint(Color(hex: "FFAE17")).interactive())
                                        }
                                        .frame(width: buttonGeometry.size.width, alignment: .leading)
                                        .gesture(DragGesture().onChanged { value in
                                            letsGoOffset = value.location.x
                                        }.onEnded { value in
                                            if value.location.x >= buttonGeometry.size.width / 2 {
                                                withAnimation(.easeInOut) {
                                                    letsGoOffset = buttonGeometry.size.width
                                                }
                                                airportsService.flight()
                                                onTabCallback(.flight(.fly(.map)))
                                            } else {
                                                withAnimation(.easeInOut) {
                                                    letsGoOffset = btnSize
                                                }
                                            }
                                            
                                        })
                                        .sensoryFeedback(.impact(weight: .light), trigger: letsGoOffset)
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .frame(width: max(geometry.size.width - 40, 0), height: 60, alignment: .leading)
                                .glassEffect(.regular)
                            }
                        } else {
                            Color.clear
                                .frame(height: 60)
                        }
                    }
                    if let selectedSeat = selectedSeat, let frame = seatFrames[selectedSeat] {
                        let offset: Double = geometry.size.width * 0.2
                        let offsetX: Double = selectedSeat <= 13 ? (selectedSeat % 2 == 0 ? offset : 0) : (selectedSeat % 2 == 1 ? -offset : 0)
                        let isMirror: Bool = (selectedSeat <= 13 && selectedSeat >= 7) || (selectedSeat > 13 && selectedSeat >= 20)
                        if #available(iOS 26, *) {
                            VStack(alignment: .leading, spacing: 0) {
                                Spacer()
                                Text("What do you want to focus?")
                                    .font(.custom("Montserrat", size: 22))
                                    .fontWeight(.bold)
                                ScrollView(.horizontal) {
                                    HStack(spacing: 0) {
                                        ForEach(user.favoriteMissions, id: \.self) { mission in
                                            Text("\(mission.emoji) \(mission.name)")
                                                .font(.custom("Montserrat", size: 20))
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 16)
                                                .glassEffect(.regular.tint(selectedMission == mission ? Color(hex: "FFAE17").opacity(0.5) : .white.opacity(0.15)).interactive())
                                                .padding(.horizontal, 5)
                                                .onTapGesture {
                                                    selectedMission = mission
                                                }
                                        }
                                        Image(systemName: "plus")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .frame(width: 52, height: 52)
                                            .glassEffect(.regular.tint(.white.opacity(0.15)).interactive())
                                    }
                                    .frame(height: 100)
                                }
                                .scrollIndicators(.hidden)
                            }
                            .padding(.horizontal, 10)
                            .frame(width: geometry.size.width * 0.7, height: 200)
                            .glassEffect(.regular, in: WidgetShape(offsetX: offsetX, isMirror: isMirror))
                            .position(x: frame.midX, y: frame.midY)
                            .offset(x: offsetX, y: isMirror ? -120 : 120)
                            .animation(.easeInOut, value: selectedSeat)
                        }
                    }
                }
                .coordinateSpace(name: "seatSpace")
                .onPreferenceChange(SeatPreferenceKey.self) {
                    seatFrames = $0
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0E0E0E"))
    }
}


#Preview {
    SeatSelectorScreen { _ in
        
    }
}
