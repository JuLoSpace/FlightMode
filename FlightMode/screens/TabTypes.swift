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
}

enum FlightWidgetType: Hashable {
    case setLocation
    case selectAirport
    case selectSeat
    case ticket
    case fly
}
