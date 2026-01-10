//
//  SettignsTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

enum ButtonType {
    case widget
    case toggle
}

struct SettingsTab : View {
    
    @EnvironmentObject var settingsService: SettingsService
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("SETTINGS")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("Profile")
                        .font(.custom("Montserrat", size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                    VStack(spacing: 0) {
                        Button(action: {
                            
                        }, label: {
                            Text("Home map style")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        })
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        Button(action: {
                            
                        }, label: {
                            Text("Scenarios")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        })
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        Button(action: {
                            
                        }, label: {
                            Text("Notification")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        })
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        Button(action: {
                            
                        }, label: {
                            Text("Sound & Haptics")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        })
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        Button(action: {
                            
                        }, label: {
                            Text("In-Flight settings")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        })
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        Button(action: {
                            
                        }, label: {
                            Text("Measurement units")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        })
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
//                            HStack {
//                                Text(btn.name)
//                                    .font(.custom("Montserrat", size: 20))
//                                    .fontWeight(.bold)
//                                    .foregroundStyle(.white)
//                                Spacer()
//                                Toggle("title", isOn: btn.state)
//                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FFAE17")))
//                                    .labelsHidden()
//                            }
//                            .padding(.horizontal, 20)
//                            .frame(width: geometry.size.width - 40)
//                            .padding(.vertical, 16)
//                        VStack {
//                            Line()
//                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
//                            .foregroundStyle(.white.opacity(0.38))
//                            .frame(height: 1)
//                            .padding(.horizontal, 20)
//                        }
                    }
                    .background(.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("Notifications")
                        .font(.custom("Montserrat", size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                    VStack(spacing: 0) {
                        HStack {
                            Text("Daily reminders")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Toggle("title", isOn: $settingsService.dailyReminders)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FFAE17")))
                                .labelsHidden()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        HStack {
                            Text("Achievement alerts")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Toggle("title", isOn: $settingsService.achievmentAlerts)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FFAE17")))
                                .labelsHidden()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        HStack {
                            Text("Streak warnings")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Toggle("title", isOn: $settingsService.streakWarnings)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FFAE17")))
                                .labelsHidden()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                        HStack {
                            Text("Challenge updates")
                                .font(.custom("Montserrat", size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                            Toggle("title", isOn: $settingsService.challengeUpdates)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FFAE17")))
                                .labelsHidden()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width - 40)
                        .padding(.vertical, 16)
                    }
                    .background(.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width, alignment: .topLeading)
                Text("App version \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                    .font(.custom("Montserrat", size: 14))
                    .fontWeight(.regular)
                    .padding(.vertical, 10)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    SettingsTab()
}
