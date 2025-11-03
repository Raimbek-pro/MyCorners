//
//  PlaceListInteractor.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//

import Foundation
import SwiftUI
import MapKit
final class PlaceListInteractor {
    func fetchPlaces() -> [Place] {
        // Simulate fetching from API or DB
        return [Place(name: "Raw", coordinate: CLLocationCoordinate2D(latitude: 43.24588318693632, longitude: 76.94285244957808)),
                Place(name: "Вася,Блин!", coordinate: CLLocationCoordinate2D(latitude: 43.23810987927416, longitude: 76.93683595389925)),
                Place(name: "Eva Coffee house", coordinate: CLLocationCoordinate2D(latitude: 43.204591358197, longitude: 76.89871739903094))
        ]
    }
}
