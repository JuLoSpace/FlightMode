//
//  MapScreen.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 08.01.2026.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct MapScreen: View {
    
    @EnvironmentObject var airportsService: AirportsService
    @EnvironmentObject var locationService: LocationService
    
    @State var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
    )
    
    func animateMapTo(lat: Double, lon: Double, delta: Double, duration: Double = 2.0) {
        if duration != .zero {
            withAnimation(.easeInOut(duration: duration)) {
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta),
                    )
                )
            }
        }
        else {
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
                )
            )
        }
    }
    
    var body: some View {
        Map(position: $position) {
            if let pos = locationService.location {
                Annotation("POSITION", coordinate: CLLocationCoordinate2D(latitude: pos.latitude, longitude: pos.longitude)) {
                    Color.white.opacity(0.15)
                        .frame(width: 30, height: 30)
                        .clipShape(.circle)
                        .overlay {
                            Color.white
                                .frame(width: 20, height: 20)
                                .clipShape(.circle)
                                .overlay {
                                    Color(hex: "FFAE17")
                                        .frame(width: 10, height: 10)
                                        .clipShape(.circle)
                                }
                        }
                }
                .annotationTitles(.hidden)
            }
            if let departureAirport = airportsService.departureAirport {
                Annotation("test", coordinate: CLLocationCoordinate2D(latitude: departureAirport.lat, longitude: departureAirport.lon)) {
                    Text(departureAirport.iata ?? departureAirport.icao)
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(hex: "544323"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundStyle(Color(hex: "FFAE17"))
                        }
                }
                .annotationTitles(.hidden)
                if let time = airportsService.selectedTime {
                    MapCircle(center: CLLocationCoordinate2D(latitude: departureAirport.lat, longitude: departureAirport.lon), radius: time * MetricsService.airplaneAverageSpeed)
                        .foregroundStyle(.white.opacity(0.15))
                        .stroke(.white.opacity(0.25), lineWidth: 1)
                        .mapOverlayLevel(level: .aboveLabels)
                }
                if let destinationAirport = airportsService.destinationAirport {
                    MapPolyline(coordinates: [
                        CLLocationCoordinate2D(latitude: departureAirport.lat, longitude: departureAirport.lon),
                        CLLocationCoordinate2D(latitude: destinationAirport.lat, longitude: destinationAirport.lon)
                    ])
                    .stroke(.white, lineWidth: 2,)
                }
            }
            ForEach(airportsService.showableAirports, id: \.self) { point in
                Annotation(point.airport.name ?? "airport", coordinate: CLLocationCoordinate2D(latitude: point.airport.lat, longitude: point.airport.lon)) {
                    Text((point.airport.iata != nil ? point.airport.iata : point.airport.icao) ?? point.airport.icao)
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(hex: point.airport == airportsService.destinationAirport ? "544323" : "4D4D4D"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundStyle(Color(hex: point.airport == airportsService.destinationAirport ? "FFAE17" : "FFFFFF"))
                        }
                        .onTapGesture(perform: {
                            airportsService.selectDestinationAirport(point.airport)
                        })
                }
                .annotationTitles(.hidden)
            }
        }
        .preferredColorScheme(.dark)
        .mapStyle(.standard(elevation: .realistic, emphasis: .automatic))
        .onAppear {
            locationService.requestLocation()
            locationService.locationCallback = {
                if let pos = locationService.location {
                    animateMapTo(lat: pos.latitude, lon: pos.longitude, delta: 2.0)
                }
            }
            MapService.mapMoveCallback = { lat, lon, delta, duration in
                animateMapTo(lat: lat, lon: lon, delta: delta, duration: duration)
            }
        }
    }
}
