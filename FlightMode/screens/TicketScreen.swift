//
//  TicketScreen.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 05.01.2026.
//

import SwiftUI

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
    var isWarping: Bool
//    var flightInfo: FlightInfo
    
    @State var cutXPosition: Double = 0.0
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("CYT")
                                .font(.custom("Montserrat", size: 48))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Yakataga")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("1h 18m")
                            .font(.custom("Montserrat", size: 18))
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                        VStack(alignment: .trailing) {
                            Text("ORT")
                                .font(.custom("Montserrat", size: 48))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Ketchikan")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 20)
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("14:59")
                                .font(.custom("Montserrat", size: 24))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Departure")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("829km")
                                .font(.custom("Montserrat", size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Distance")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                            .frame(maxWidth: .infinity)
                        VStack(alignment: .trailing) {
                            Text("16:17")
                                .font(.custom("Montserrat", size: 24))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Arrival")
                                .font(.custom("Montserrat", size: 14))
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    DottedLine().stroke(
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 16])
                    )
                    .frame(width: width - 60, height: 1, alignment: .top)
                    .padding(.horizontal, 30)
                    .blendMode(.destinationOut)
                    .frame(width: width, height: 20, alignment: .bottom)
                    .contentShape(.rect)
                    .gesture(DragGesture().onChanged { value in
                        if value.location.x > 24 {
                            cutXPosition = max(cutXPosition, value.location.x)
                        }
                        if cutXPosition > width * 0.9 {
                            withAnimation(.easeInOut) {
                                cutXPosition = width * 2
                            }
                        }
//                        cutXPosition = value.location.x
                    })
                }
                .padding(.top, 20)
                .frame(width: width, alignment: .bottom)
                .background(LinearGradient(colors: [
                    Color(hex: "323232"),
                    Color(hex: "212121")
                ], startPoint: .leading, endPoint: .trailing))
                .clipShape(TicketShapeTop(cornerRadius: 16, centerRadius: 24))
                let bottomTicket = VStack(alignment: .center, spacing: 0) {
                    DottedLine().stroke(
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 16])
                    )
                    .frame(width: width - 60, height: 1, alignment: .top)
                    .padding(.horizontal, 30)
                    .blendMode(.destinationOut)
                    Spacer()
                    Image("barcode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(width: width, height: height * 3/8, alignment: .top)
                .background(LinearGradient(colors: [
                    Color(hex: "323232"),
                    Color(hex: "212121")
                ], startPoint: .leading, endPoint: .trailing))
                .clipShape(TicketShapeBottom(cornerRadius: 16, centerRadius: 24))
                if isWarping {
                    bottomTicket
                        .distortionEffect(ShaderLibrary.ticketWarp(
                            .float2(Float(width), Float(height)),
                            .float(cutXPosition / width),
                        ), maxSampleOffset: CGSize(width: 0, height: height))
                } else {
                    bottomTicket
                }
            }
        }
    }
}
struct TicketScreen: View {
    
    var body: some View {
        TicketView(width: 400, height: 300, isWarping: true)
    }
}


#Preview {
    TicketScreen()
}
