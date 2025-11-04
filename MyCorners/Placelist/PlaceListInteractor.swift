//
//  PlaceListInteractor.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//
import FirebaseFirestore
import CoreLocation
import FirebaseAuth
import Foundation
import SwiftUI
import MapKit
final class PlaceListInteractor {
//    func fetchPlaces() -> [Place] {
//        // Simulate fetching from API or DB
//        return [Place(name: "Raw", coordinate: CLLocationCoordinate2D(latitude: 43.24588318693632, longitude: 76.94285244957808)),
//                Place(name: "Вася,Блин!", coordinate: CLLocationCoordinate2D(latitude: 43.23810987927416, longitude: 76.93683595389925)),
//                Place(name: "Eva Coffee house", coordinate: CLLocationCoordinate2D(latitude: 43.204591358197, longitude: 76.89871739903094))
//        ]
//    }
    
    private let db = Firestore.firestore()
    
    
    func fetchPlaces(completion: @escaping ([Place]) -> Void) {
            db.collection("places").getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching places: \(error)")
                    completion([])
                    return
                }
                
                let places = snapshot?.documents.compactMap { doc -> Place? in
                    guard
                        let name = doc["name"] as? String,
                        let lat = doc["latitude"] as? Double,
                        let lng = doc["longitude"] as? Double
                    else { return nil }
                    
                    return Place(
                        id: doc.documentID,
                        name: name,
                        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    )
                } ?? []
                
                completion(places)
            }
        }
        
    func addPlace(_ place: Place, completion: ((Error?) -> Void)? = nil) {
        let ref = db.collection("places").document() // creates a reference with a generated ID
        
        
        guard let userId = AuthManager.shared.currentUserId else { return }
        
        let placeWithID = Place(
            id: ref.documentID,
            name: place.name,
            coordinate: place.coordinate
        )
        
        
        
        ref.setData([
            "userId": userId,
            "name": placeWithID.name,
            "latitude": placeWithID.coordinate.latitude,
            "longitude": placeWithID.coordinate.longitude
        ]) { error in
            if let error = error {
                print("❌ Failed to add place: \(error.localizedDescription)")
            } else {
                print("✅ Place added with ID: \(placeWithID.id)")
            }
            completion?(error)
        }
    }}
