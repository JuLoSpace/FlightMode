//
//  ViewExtension.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 30.12.2025.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func adaptiveGlassEffect() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear.interactive())
        } else {
            self.background(.ultraThinMaterial)
        }
    }
    
    @ViewBuilder
    func adaptiveGlassEffect(shape: some Shape) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear.interactive(), in: shape)
        } else {
            self.background(.ultraThinMaterial)
                .clipShape(shape)
        }
    }
    
    @ViewBuilder
    func adaptiveGlassEffect(color: Color) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear.tint(color).interactive())
        } else {
            self.background(color.opacity(0.5))
        }
    }
    
    @ViewBuilder
    func adaptiveGlassEffect(color: Color, shape: some Shape) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear.tint(color).interactive(), in: shape)
        } else {
            self.background(color.opacity(0.5))
                .clipShape(shape)
        }
    }
    
    @ViewBuilder
    func adaptiveButtonStyle(color: Color) -> some View {
        if #available(iOS 26, *) {
            self.buttonStyle(.glass)
                .tint(color)
        } else {
            self.buttonStyle(.bordered)
                .tint(color)
        }
    }
}
