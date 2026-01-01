//
//  FlightAcademyTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

struct FlightAcademyTab : View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical) {
                    HStack {
                        Text("FLIGHT ACADEMY")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    .frame(width: geometry.size.width, alignment: .topLeading)
                    if #available(iOS 26, *) {
                        VStack {
                            HStack(alignment: .center) {
                                Image("ace")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(20))
                                    .padding(.all, 5)
                                    .background(Color(hex: "FFAE17"))
                                    .clipShape(.circle)
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .center) {
                                        Text("Ace Pilot")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                        +
                                        Text(" → ")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white.opacity(0.25))
                                        +
                                        Text("Legend")
                                            .font(.custom("Montserrat", size: 12))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white.opacity(0.25))
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
                            .glassEffect()
                        }
                        .padding(.horizontal, 20)
                        VStack {
                            ForEach(0..<5, id: \.self) { i in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Flight")
                                            .font(.custom("Montserrat", size: 24))
                                            .foregroundStyle(.white.opacity(0.5))
                                        Text("24")
                                            .font(.custom("Montserrat", size: 32))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .padding(.top, 20)
                                    }
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 20)
                                    .frame(width: geometry.size.width * 0.44, alignment: .leading)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    VStack(alignment: .leading) {
                                        Text("Flight")
                                            .font(.custom("Montserrat", size: 24))
                                            .foregroundStyle(.white.opacity(0.5))
                                        Text("24")
                                            .font(.custom("Montserrat", size: 32))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .padding(.top, 20)
                                    }
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 20)
                                    .frame(width: geometry.size.width * 0.44, alignment: .leading)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width)
                    }
                }
            }
        }
    }
}

#Preview {
    FlightAcademyTab()
}
