//
//  FeedInteractor.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 07.11.2025.
//

import FirebaseFirestore
import CoreLocation

final class FeedInteractor {
    private let db = Firestore.firestore()
    
    func fetchFeed(completion: @escaping ([FeedPost]) -> Void) {
        db.collection("feedPosts")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error loading feed:", error.localizedDescription)
                    completion([])
                    return
                }

                let posts = snapshot?.documents.compactMap { doc -> FeedPost? in
                    guard let title = doc["title"] as? String,
                          let placesData = doc["places"] as? [[String: Any]] else { return nil }
                    
                    let places = placesData.compactMap { data -> Place? in
                        guard let name = data["name"] as? String,
                              let lat = data["latitude"] as? Double,
                              let lng = data["longitude"] as? Double else { return nil }
                        return Place(
                            id: UUID().uuidString,
                            name: name,
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        )
                    }
                    
                    return FeedPost(id: doc.documentID, title: title, places: places)
                } ?? []
                
                completion(posts)
            }
    }
}
