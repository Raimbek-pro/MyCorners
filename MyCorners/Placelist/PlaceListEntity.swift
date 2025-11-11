//
//  PlaceListEntity.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//
import Foundation
import SwiftUI
import MapKit

struct Place: Identifiable, Equatable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    // Optional: customize equality if needed
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id // usually comparing by unique id is enough
    }
}
