//
//  TabRouter.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//


enum TabWidgetType: Hashable {
    case home
    case flightAcademy
    case history
    case settings
    case flight(FlightWidgetType)
    case avatar
}

enum FlightWidgetType: Hashable {
    case setLocation
    case selectAirport
    case selectSeat
    case ticket
    case fly(FlyWidgetType)
    case destination
}

enum FlyWidgetType: Hashable, CaseIterable {
    case map
    case cockpit
    case music
    case pause
}
