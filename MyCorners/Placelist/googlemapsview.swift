//
//  googlemapsview.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 03.11.2025.
//
import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    
    var places : [Place]
 
    let zoom: Float

    func makeUIView(context: Context) -> GMSMapView {
        // Create options object
        let initialLocation = places.first?.coordinate ?? CLLocationCoordinate2D(latitude: 43.24, longitude: 76.88)
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: initialLocation.latitude, longitude: initialLocation.longitude, zoom: zoom)
        
        // Initialize map using the recommended initializer
        let mapView = GMSMapView(options: options)
        mapView.delegate = context.coordinator
        for place in places{
                       let marker = GMSMarker()
                       marker.position = place.coordinate
                       marker.title = place.name
                       marker.map = mapView
        }
     

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        
        
        // Clear previous markers
             uiView.clear()

             // Add new markers
             for place in places {
                 let marker = GMSMarker()
                 marker.position = place.coordinate
                 marker.title = place.name
                 marker.map = uiView
             }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        // Handle marker taps or other delegate events
    }
}
