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
        return [Place(name: "Favorite Spot", coordinate: .init(latitude: 43.24, longitude: 76.88))]
    }
}
