//
//  FlyOverlay.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//

import SwiftUI

enum FlyStyle {
    case map
    case cockpit
}

struct FlyOverlay: View {
    
    @State var selectedFlyStyle: FlyStyle = FlyStyle.map
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                let pauseButton = Button(action: {
                    
                }, label: {
                    Image("pause")
                        .frame(width: 50, height: 50)
                })
                if #available(iOS 26, *) {
                    pauseButton
                        .buttonBorderShape(.circle)
                        .buttonStyle(.glass)
                }
                Spacer()
                HStack {
                    let musicButton = Button(action: {
                        
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
            .frame(maxWidth: .infinity)
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
                    selectedFlyStyle = .cockpit
                }
            }
            .frame(width: selectFlyStyleWidth, height: 60)
            if #available(iOS 26, *) {
                selectFlyStyle
                    .glassEffect()
            }
        }
        .frame(maxHeight: .infinity)
    }
}


#Preview {
    FlyOverlay()
}
