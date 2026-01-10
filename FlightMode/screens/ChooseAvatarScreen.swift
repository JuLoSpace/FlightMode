//
//  ChooseAvatarScreen.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 10.01.2026.
//


import SwiftUI

struct ChooseAvatarScreen: View {
    
    @State var name: String = ""
    @State var selectedSex: SexType?
    
    var onTabCallback: (TabWidgetType) -> ()
    
    @EnvironmentObject var settingsService: SettingsService
    
    var body: some View {
        VStack(alignment: .leading) {
            if #available(iOS 26, *) {
                Button(action: {
                    onTabCallback(TabWidgetType.home)
                }, label: {
                    Image(systemName: "chevron.backward")
                        .padding(.all, 6)
                })
                .buttonBorderShape(.circle)
                .buttonStyle(GlassButtonStyle())
                .padding(.horizontal, 20)
            } else {
                Button(action: {
                    onTabCallback(TabWidgetType.home)
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
                Text("CHOOSE ")
                    .font(.custom("Wattauchimma", size: 40))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                +
                Text("AVATAR")
                    .font(.custom("Wattauchimma", size: 40))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: "FFAE17"))
            }
            .padding(.horizontal, 20)
            ZStack {
                Color.clear
                    .background(LinearGradient(colors: [
                        Color(hex: "FFAE17"),
                        Color(hex: "FFAE17").opacity(0.0)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(32)
                Image("man")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(0.4, anchor: .top)
                    .frame(height: 200, alignment: .top)
                    .clipped()
                    .frame(maxWidth: .infinity, alignment: .top)
                if let selectedSex = selectedSex, selectedSex == .man {
                    RoundedRectangle(cornerRadius: 32).stroke(style: .init(lineWidth: 2))
                        .foregroundStyle(Color(hex: "FFAE17"))
                } else {
                    RoundedRectangle(cornerRadius: 32).stroke(style: .init(lineWidth: 2))
                }
            }
            .frame(height: 200, alignment: .top)
            .padding(.horizontal, 20)
            .onTapGesture {
                selectedSex = .man
            }
            ZStack {
                Color.clear
                    .background(LinearGradient(colors: [
                        Color(hex: "FFAE17"),
                        Color(hex: "FFAE17").opacity(0.0)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(32)
                Image("woman")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(0.4, anchor: .top)
                    .frame(height: 200, alignment: .top)
                    .clipped()
                    .frame(maxWidth: .infinity, alignment: .top)
                if let selectedSex = selectedSex, selectedSex == .woman {
                    RoundedRectangle(cornerRadius: 32).stroke(style: .init(lineWidth: 2))
                        .foregroundStyle(Color(hex: "FFAE17"))
                } else {
                    RoundedRectangle(cornerRadius: 32).stroke(style: .init(lineWidth: 2))
                }
            }
            .frame(height: 200, alignment: .top)
            .padding(.horizontal, 20)
            .onTapGesture {
                selectedSex = .woman
            }
            Spacer()
            Text("Enter your name")
                .font(.custom("Montserrat", size: 16))
                .fontWeight(.regular)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
            let textField = TextField("", text: $name, prompt: Text("Cadet of FlightMode").foregroundStyle(.white.opacity(0.5)))
                .textContentType(.name)
                .accentColor(.white)
                .foregroundStyle(.white)
                .disableAutocorrection(true)
                .font(.custom("Montserrat", size: 24))
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .onSubmit {
                    
                }
                .padding(.horizontal, 20)
            if #available(iOS 26, *) {
                textField
                    .glassEffect(.clear)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            } else {
                textField
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
            if #available(iOS 26, *) {
                Button(action: {
                    settingsService.name = name
                    settingsService.sexType = selectedSex
                    onTabCallback(TabWidgetType.home)
                }, label: {
                    Text("Continue")
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                })
                .frame(maxWidth: .infinity)
                .glassEffect(.regular.tint(Color(hex: "FFAE17")).interactive())
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(hex: "0E0E0E"))
    }
}

#Preview {
    ChooseAvatarScreen { _ in
        
    }
}
