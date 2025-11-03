//
//  googlemapsview.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 03.11.2025.
//
import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    let zoom: Float

    func makeUIView(context: Context) -> GMSMapView {
        // Create options object
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: zoom)
        
        // Initialize map using the recommended initializer
        let mapView = GMSMapView(options: options)
        mapView.delegate = context.coordinator

        // Optional: add a default marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Default Location"
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Update markers or camera if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        // Handle marker taps or other delegate events
    }
}
