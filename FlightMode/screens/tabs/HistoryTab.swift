//
//  HistoryTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

//struct TicketShapeTop: Shape {
//    
//    var cornerRadius: Double
//    var centerRadius: Double
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
//        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
//        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        path.addLine(to: CGPoint(x: 0, y: rect.height))
//        path.move(to: CGPoint(x: 0, y: rect.height - cornerRadius))
//        path.addLine(to: CGPoint(x: 0, y: rect.height))
//        path.addArc(center: CGPoint(x: 0, y: rect.height), radius: centerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
//        path.move(to: CGPoint(x: rect.width, y: rect.height))
//        path.addArc(center: CGPoint(x: rect.width, y: rect.height), radius: centerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
//        return path
//    }
//}
//
//struct TicketShapeBottom: Shape {
//    
//    var cornerRadius: Double
//    var centerRadius: Double
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: rect.width, y: 0))
//        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
//        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addArc(center: CGPoint(x: 0, y: 0), radius: centerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: true)
//        path.move(to: CGPoint(x: rect.width, y: 0))
//        path.addArc(center: CGPoint(x: rect.width, y: 0), radius: centerRadius, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
//        return path
//    }
//}

enum HistoryType: CaseIterable {
    case total
    case week
    case month
    case year
    
    func getName() -> String {
        switch self {
        case .total:
            return "Total"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
}

struct DottedLine: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

//struct TicketView: View {
//    
//    var width: Double
//    var height: Double
//    var isWarping: Bool
////    var flightInfo: FlightInfo
//    
//    @State var cutXPosition: Double = 0.0
//    
//    var body: some View {
//        ZStack(alignment: .center) {
//            VStack(alignment: .leading, spacing: 0) {
//                VStack(alignment: .leading, spacing: 0) {
//                    HStack(alignment: .top) {
//                        Text("CYT")
//                            .font(.custom("Montserrat", size: 40))
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        VStack(spacing: 0) {
//                            Text("Success")
//                                .font(.custom("Montserrat", size: 14))
//                                .fontWeight(.bold)
//                                .foregroundStyle(Color(hex: "3EC632"))
//                            HStack(spacing: 5) {
//                                DottedLine().stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
//                                    .frame(height: 2)
//                                    .padding(.vertical, 10)
//                                    .foregroundStyle(.white.opacity(0.15))
//                                Image("success")
//                                DottedLine().stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
//                                    .frame(height: 2)
//                                    .padding(.vertical, 10)
//                                    .foregroundStyle(.white.opacity(0.15))
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        Text("ORT")
//                            .font(.custom("Montserrat", size: 40))
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    }
//                    .padding(.horizontal, 30)
//                    HStack {
//                        Text("Yakataga")
//                            .font(.custom("Montserrat", size: 14))
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white.opacity(0.25))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        Text("1 h 18 m")
//                            .font(.custom("Montserrat", size: 14))
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white.opacity(0.5))
//                            .frame(maxWidth: .infinity, alignment: .center)
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text("Ketchikan")
//                                .font(.custom("Montserrat", size: 14))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white.opacity(0.25))
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                    DottedLine().stroke(
//                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 16])
//                    )
//                    .frame(width: width - 60, height: 1)
//                    .padding(.horizontal, 30)
//                    .foregroundStyle(.white.opacity(0.05))
//                    .frame(width: width, height: 20, alignment: .bottom)
//                    .contentShape(.rect)
//                    .gesture(DragGesture().onChanged { value in
//        //                cutXPosition = max(cutXPosition, value.location.x)
//                        cutXPosition = value.location.x
//                    })
//                }
//                .frame(width: width, height: height / 2, alignment: .bottom)
//                .background(LinearGradient(colors: [
//                    Color(hex: "323232"),
//                    Color(hex: "212121")
//                ], startPoint: .leading, endPoint: .trailing))
//                .clipShape(TicketShapeTop(cornerRadius: 16, centerRadius: 24))
//                let bottomTicket = VStack(alignment: .center, spacing: 0) {
//                    DottedLine().stroke(
//                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 16])
//                    )
//                    .frame(width: width - 60, height: 1, alignment: .top)
//                    .padding(.horizontal, 30)
//                    .foregroundStyle(.white.opacity(0.05))
//                    Spacer()
//                    HStack {
//                        HStack(spacing: 2) {
//                            Image("date")
//                                .font(.system(size: 20))
//                            Text("14:59")
//                                .font(.custom("Montserrat", size: 18))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        HStack(spacing: 2) {
//                            Image("place")
//                                .font(.system(size: 20))
//                            Text("829 km")
//                                .font(.custom("Montserrat", size: 18))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        HStack(spacing: 2) {
//                            Image("date")
//                                .font(.system(size: 20))
//                            Text("14:59")
//                                .font(.custom("Montserrat", size: 18))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                    }
//                    .padding(.horizontal, 30)
//                    HStack {
//                        HStack {
//                            Text("Departure")
//                                .font(.custom("Montserrat", size: 10))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white.opacity(0.25))
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        HStack {
//                            Text("Distance")
//                                .font(.custom("Montserrat", size: 10))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white.opacity(0.25))
//                        }
//                            .frame(maxWidth: .infinity, alignment: .center)
//                        HStack {
//                            Text("Arrival")
//                                .font(.custom("Montserrat", size: 10))
//                                .fontWeight(.bold)
//                                .foregroundStyle(.white.opacity(0.25))
//                        }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    }
//                    .padding(.horizontal, 30)
//                    Spacer()
//                }
//                .frame(width: width, height: height / 2, alignment: .center)
//                .background(LinearGradient(colors: [
//                    Color(hex: "323232"),
//                    Color(hex: "212121")
//                ], startPoint: .leading, endPoint: .trailing))
//                .clipShape(TicketShapeBottom(cornerRadius: 16, centerRadius: 24))
//                if isWarping {
//                    bottomTicket
//                        .distortionEffect(ShaderLibrary.ticketWarp(
//                            .float2(Float(width), Float(height)),
//                            .float(cutXPosition / width),
//                        ), maxSampleOffset: CGSize(width: 0, height: height))
//                } else {
//                    bottomTicket
//                }
//            }
//        }
//    }
//}

struct FlightInfo {
    var departure: String
    var destination: String
    var departureTime: Date
    var destinationTime: Date
    var distance: Double
    
    func getFlightTime() -> String {
        let interval: TimeInterval = destinationTime.timeIntervalSince(departureTime)
        let s: Int = Int(interval)
        let m: Int = s / 60
        let hours: Int = m / 60
        let minutes: Int = m % 60
        return "\(hours) h \(minutes) m"
    }
}

struct HistoryTab : View {
    
    @State var selectedHistoryType: HistoryType = HistoryType.total
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    HStack {
                        Text("HISTORY")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .frame(width: geometry.size.width - 40, alignment: .leading)
                    HStack(spacing: 10) {
                        ForEach(HistoryType.allCases, id: \.self) { historyType in
                            if #available(iOS 26, *) {
                                Button(action: {
                                    selectedHistoryType = historyType
                                }, label: {
                                    Text(historyType.getName())
                                        .font(.custom("Montserrat", size: 14))
                                        .fontWeight(.bold)
                                        .foregroundStyle(selectedHistoryType == historyType ? .black : .white)
                                })
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .glassEffect(.regular.tint(selectedHistoryType == historyType ? .white : .white.opacity(0.2)).interactive())
                                .lineLimit(1)
                            }
                        }
                    }
                    .frame(width: geometry.size.width - 40, alignment: .leading)
                    .padding(.horizontal, 20)
//                    TicketView(width: geometry.size.width - 40, height: 200, isWarping: true)
//                    .frame(width: geometry.size.width - 40, alignment: .leading)
//                    .padding(.horizontal, 20)
                }
            }
        }
    }
}


#Preview {
    HistoryTab()
}
