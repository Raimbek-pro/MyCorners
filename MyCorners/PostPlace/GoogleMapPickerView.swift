//
//  GoogleMapPickerView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 06.11.2025.
//

import SwiftUI
import GoogleMaps

struct GoogleMapPickerView: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(latitude: 43.238949, longitude: 76.889709, zoom: 12)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
        if let coord = coordinate {
            let marker = GMSMarker(position: coord)
            marker.map = uiView
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapPickerView

        init(_ parent: GoogleMapPickerView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            parent.coordinate = coordinate
        }
    }
}
