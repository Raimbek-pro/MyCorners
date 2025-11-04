//
//  PlaceListEntity.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//
import Foundation
import SwiftUI
import MapKit

struct Place: Identifiable {
    let id: String  // Firestore doc ID
    let name: String
    let coordinate: CLLocationCoordinate2D
}
