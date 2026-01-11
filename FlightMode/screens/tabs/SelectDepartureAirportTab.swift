//
//  SelectDepartureAirportTab.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 11.01.2026.
//

import SwiftUI



struct SelectDepartureAirportTab: View {
    
    @EnvironmentObject var airportsService: AirportsService
    
    @State var query: String = ""
    
    @State var airports: [String: [Airport]]?
    
    var onTabCallback: (TabWidgetType) -> ()
    
    var body: some View {
        ScrollView {
            Text("SET HOME BASE")
                .font(.custom("Wattauchimma", size: 48))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
            Text("Don't worry, your location stays private on this device.")
                .font(.custom("Montserrat", size: 14))
                .fontWeight(.regular)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
            let textField = TextField("", text: $query, prompt: Text("Search").foregroundStyle(.white.opacity(0.5)))
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
                .onChange(of: query) {
                    airports = airportsService.searchAirportsByQuery(query)
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
            if let airports = airports {
                ForEach(Array(airports.keys), id: \.self) { cityName in
                    Text(cityName)
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    if let a = airports[cityName] {
                        ForEach(Array(a), id: \.self) { airport in
                            let code = airport.iata ?? airport.icao
                            let name = airport.name != nil ? " (\(airport.name!))" : ""
                            Text(code + name)
                                .font(.custom("Montserrat", size: 16))
                                .lineLimit(1)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    airportsService.setDepartureAirport(airport)
                                    onTabCallback(TabWidgetType.flight(.selectAirport))
                                }
                        }
                    }
                    Color.white.opacity(0.25)
                        .frame(maxWidth: .infinity)
                        .frame(height: 2)
                        .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


#Preview {
    SelectDepartureAirportTab { _ in
        
    }
}
