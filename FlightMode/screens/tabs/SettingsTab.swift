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

struct SettingsButton: Hashable {
    
    static func == (lhs: SettingsButton, rhs: SettingsButton) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    
    var name: String
    var type: ButtonType
    var onButtonTap: (() -> ())
}

struct SettingsTab : View {
    
    let buttons: [String: [SettingsButton]] = [
        "Profile": [
            SettingsButton(name: "Home map style", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Scenarios", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Notifications", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Sound & Haptics", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "In-Flight settings", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Measurement units", type: ButtonType.widget, onButtonTap: {})
        ],
        "Notifications": [
            SettingsButton(name: "Daily remainders", type: ButtonType.toggle, onButtonTap: {}),
            SettingsButton(name: "Achievement alerts", type: ButtonType.toggle, onButtonTap: {}),
            SettingsButton(name: "Streak warnings", type: ButtonType.toggle, onButtonTap: {}),
            SettingsButton(name: "Challenge updates", type: ButtonType.toggle, onButtonTap: {})
        ],
        "Subscription": [
            SettingsButton(name: "Manage Subscription", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Restore purchases", type: ButtonType.widget, onButtonTap: {}),
        ],
        "About": [
            SettingsButton(name: "Terms of Service", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Privacy policy", type: ButtonType.widget, onButtonTap: {}),
            SettingsButton(name: "Contact support", type: ButtonType.widget, onButtonTap: {}),
        ],
    ]
    
    @State private var test: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("SETTINGS")
                        .font(.custom("Wattauchimma", size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    ForEach(Array(buttons.keys.sorted(by: {a, b in
                        let k: [String: Int] = [
                            "Profile": 0,
                            "Notifications": 1,
                            "Subscription": 2,
                            "About": 3
                        ]
                        return k[a]! < k[b]!
                    })), id: \.self) { sect in
                        Text(sect)
                            .font(.custom("Montserrat", size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.5))
                        VStack(spacing: 0) {
                            ForEach(buttons[sect] ?? [], id: \.self) { btn in
                                
                                if btn.type == ButtonType.widget {
                                    Button(action: {
                                        
                                    }, label: {
                                        Text(btn.name)
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
                                } else {
                                    HStack {
                                        Text(btn.name)
                                            .font(.custom("Montserrat", size: 20))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Toggle("title", isOn: $test)
                                            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FFAE17")))
                                            .labelsHidden()
                                    }
                                    .padding(.horizontal, 20)
                                    .frame(width: geometry.size.width - 40)
                                    .padding(.vertical, 16)
                                }
                                
                                let index = buttons[sect]?.firstIndex(where: {$0 == btn})
                                if (index != (buttons[sect]?.count ?? 0) - 1) {
                                    VStack {
                                        Line()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                        .foregroundStyle(.white.opacity(0.38))
                                        .frame(height: 1)
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                        }
                        .background(.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
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
