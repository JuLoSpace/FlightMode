//
//  TicketVie.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 09.01.2026.
//

import SwiftUI

struct DottedLine: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct TicketShapeTop: Shape {
    
    var cornerRadius: Double
    var centerRadius: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.move(to: CGPoint(x: 0, y: rect.height - cornerRadius))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addArc(center: CGPoint(x: 0, y: rect.height), radius: centerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
        path.move(to: CGPoint(x: rect.width, y: rect.height))
        path.addArc(center: CGPoint(x: rect.width, y: rect.height), radius: centerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
        return path
    }
}

struct TicketShapeBottom: Shape {
    
    var cornerRadius: Double
    var centerRadius: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(center: CGPoint(x: 0, y: 0), radius: centerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: true)
        path.move(to: CGPoint(x: rect.width, y: 0))
        path.addArc(center: CGPoint(x: rect.width, y: 0), radius: centerRadius, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
        return path
    }
}

struct TicketView: View {

    var width: Double
    var height: Double
    var flight: Flight

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        Text(flight.airportDeparture.icao)
                            .font(.custom("Montserrat", size: 28))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack(spacing: 0) {
                            Text("\(flight.flightProcess.flightType)")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "3EC632"))
                            HStack(spacing: 5) {
                                DottedLine().stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                    .frame(height: 2)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(.white.opacity(0.15))
                                Image("success")
                                DottedLine().stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                    .frame(height: 2)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(.white.opacity(0.15))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        Text(flight.airportDestination.icao)
                            .font(.custom("Montserrat", size: 28))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 30)
                    HStack {
                        if let city = flight.airportDeparture.city {
                            Text("\(city)")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.25))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if let timeDestination = flight.timeDestination, let timeDeparture = flight.timeDeparture {
                            Text(TimeTranslate.secToString(timeDestination.timeIntervalSince(timeDeparture)))
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        if let city = flight.airportDestination.city {
                            Text("\(city)")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.25))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal, 30)
                    DottedLine().stroke(
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 16])
                    )
                    .frame(width: max(width - 60, 0), height: 1)
                    .padding(.horizontal, 30)
                    .foregroundStyle(.white.opacity(0.05))
                    .frame(width: width, height: 20, alignment: .bottom)
                    .contentShape(.rect)
                }
                .frame(width: width, height: height / 2, alignment: .bottom)
                .background(LinearGradient(colors: [
                    Color(hex: "323232"),
                    Color(hex: "212121")
                ], startPoint: .leading, endPoint: .trailing))
                .clipShape(TicketShapeTop(cornerRadius: 16, centerRadius: 24))
                VStack(alignment: .center, spacing: 0) {
                    DottedLine().stroke(
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 16])
                    )
                    .frame(width: max(width - 60, 0), height: 1, alignment: .top)
                    .padding(.horizontal, 30)
                    .foregroundStyle(.white.opacity(0.05))
                    Spacer()
                    HStack {
                        HStack(spacing: 2) {
                            Image("date")
                                .font(.system(size: 20))
                            if let timeDeparture = flight.timeDeparture {
                                Text(timeDeparture, format: .dateTime.hour().minute())
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 2) {
                            Image("place")
                                .font(.system(size: 20))
                            Text("\(Int(MetricsService.distance(a: flight.airportDeparture, b: flight.airportDestination) / 1000)) km")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        HStack(spacing: 2) {
                            Image("date")
                                .font(.system(size: 20))
                            if let timeDestination = flight.timeDestination {
                                Text(timeDestination, format: .dateTime.hour().minute())
                                    .font(.custom("Montserrat", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 30)
                    HStack {
                        HStack {
                            Text("Departure")
                                .font(.custom("Montserrat", size: 10))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.25))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text("Distance")
                                .font(.custom("Montserrat", size: 10))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.25))
                        }
                            .frame(maxWidth: .infinity, alignment: .center)
                        HStack {
                            Text("Arrival")
                                .font(.custom("Montserrat", size: 10))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.25))
                        }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 30)
                    Spacer()
                }
                .frame(width: width, height: height / 2, alignment: .center)
                .background(LinearGradient(colors: [
                    Color(hex: "323232"),
                    Color(hex: "212121")
                ], startPoint: .leading, endPoint: .trailing))
                .clipShape(TicketShapeBottom(cornerRadius: 16, centerRadius: 24))
            }
        }
    }
}


#Preview {
    TicketView(width: 400, height: 200, flight: Flight(flightProcess: FlightProcess(flightType: .success, position: Position(latitude: 0.0, longitude: 0.0)), airportDeparture: Airport(icao: "CYT", iata: nil, name: "Yakataga", city: "Yakataga", country: nil, elevation: nil, lat: 0.0, lon: 0.0, tz: nil), airportDestination: Airport(icao: "ORT", iata: nil, name: "Ketchikan", city: "Ketchikan", country: nil, elevation: nil, lat: 0.0, lon: 0.0, tz: nil), timeDeparture: Date.now, timeDestination: Date.now, id: UUID()))
}

#Preview {
    TicketView(width: 400, height: 200, flight: Flight(flightProcess: FlightProcess(flightType: .cancelled, position: Position(latitude: 0.0, longitude: 0.0)), airportDeparture: Airport(icao: "CYT", iata: nil, name: "Yakataga", city: "Yakataga", country: nil, elevation: nil, lat: 0.0, lon: 0.0, tz: nil), airportDestination: Airport(icao: "ORT", iata: nil, name: "Ketchikan", city: "Ketchikan", country: nil, elevation: nil, lat: 0.0, lon: 0.0, tz: nil), timeDeparture: Date.now, timeDestination: Date.now, id: UUID()))
}
