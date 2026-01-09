//
//  HomeOverlay.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//

import SwiftUI


struct HomeOverlay: View {
    
    var body: some View {
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
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
