//
//  HistoryTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 01.01.2026.
//

import SwiftUI

enum HistoryType: CaseIterable {
    case total
    case week
    case month
    case year
    
    func getName() -> String {
        switch self {
        case .total:
            return "Total"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
    
    func getSeconds() -> Int {
        switch self {
        case .total:
            return Int(1e18)
        case .week:
            return 7 * 24 * 3600
        case .month:
            return 30 * 7 * 24 * 3600
        case .year:
            return 365 * 7 * 24 * 3600
        }
    }
}

struct HistoryTab : View {
    
    @State var selectedHistoryType: HistoryType = HistoryType.total
    @EnvironmentObject var airportsService: AirportsService
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    HStack {
                        Text("HISTORY")
                            .font(.custom("Wattauchimma", size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    HStack(spacing: 10) {
                        ForEach(HistoryType.allCases, id: \.self) { historyType in
                            if #available(iOS 26, *) {
                                Button(action: {
                                    selectedHistoryType = historyType
                                }, label: {
                                    Text(historyType.getName())
                                        .font(.custom("Montserrat", size: 14))
                                        .fontWeight(.bold)
                                        .foregroundStyle(selectedHistoryType == historyType ? .black : .white)
                                })
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .glassEffect(.regular.tint(selectedHistoryType == historyType ? .white : .white.opacity(0.2)).interactive())
                                .lineLimit(1)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    if let flights = airportsService.historyFlights {
                        let showable: [Flight] = flights.filter {
                            if let timeDestination = $0.timeDestination {
                                return Int(Date.now.timeIntervalSince(timeDestination)) < selectedHistoryType.getSeconds()
                            }
                            return false
                        }
                        ForEach(showable, id: \.self) { flight in
                            TicketView(width: .infinity, height: 200, flight: flight)
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    HistoryTab()
}
