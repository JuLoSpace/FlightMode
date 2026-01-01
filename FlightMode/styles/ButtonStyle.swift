//
//  ButtonStyle.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 30.12.2025.
//

import SwiftUI


struct CustomButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(color)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
