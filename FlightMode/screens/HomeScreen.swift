//
//  HomeScreen.swift
//  FlightModeTest
//
//  Created by Ярослав Соловьев on 20.12.2025.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct HomeScreen : View {
    
    let position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    var body: some View {
        Map(initialPosition: position) {
            Annotation(locations[0].name, coordinate: locations[0].coordinate) {
                Text(locations[0].name)
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .glassEffect()
            }
            .annotationTitles(.hidden)
        }
            .mapStyle(.hybrid(elevation: .realistic))
    }
}

#Preview {
    HomeScreen()
}
