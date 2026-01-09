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
}

struct HistoryTab : View {
    
    @State var selectedHistoryType: HistoryType = HistoryType.total
    
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
                    .frame(width: geometry.size.width - 40, alignment: .leading)
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
                    .frame(width: geometry.size.width - 40, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                }
            }
        }
    }
}


#Preview {
    HistoryTab()
}
