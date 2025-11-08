import FirebaseFirestore
import CoreLocation
import FirebaseAuth
import Foundation
import SwiftUI
import MapKit

final class PlaceListInteractor {
    private let db = Firestore.firestore()

    init() {
        db.collection("places").limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("❌ Firestore connection failed: \(error.localizedDescription)")
            } else {
                print("✅ Firestore connected (\(snapshot?.documents.count ?? 0) docs)")
            }
        }
    }

    // MARK: - CREATE a new Feed Post
    func createFeedPost(
        title: String,
        places: [Place],
        completion: ((Error?, String?) -> Void)? = nil
    ) {
        guard let userId = AuthManager.shared.currentUserId else { return }

        let feedRef = db.collection("feedPosts").document()
        let placesData = places.map { [
            "name": $0.name,
            "latitude": $0.coordinate.latitude,
            "longitude": $0.coordinate.longitude
        ]}

        let data: [String: Any] = [
            "userId": userId,
            "title": title,
            "places": placesData,
            "timestamp": FieldValue.serverTimestamp()
        ]

        feedRef.setData(data) { error in
            if let error = error {
                print("❌ Failed to create feed post: \(error.localizedDescription)")
            } else {
                print("✅ Feed post created with ID: \(feedRef.documentID)")
            }
            completion?(error, feedRef.documentID)
        }
    }

    // MARK: - UPDATE existing Feed Post (append new places)
    func updateFeedPost(
        id: String,
        newPlaces: [Place],
        completion: ((Error?) -> Void)? = nil
    ) {
        let ref = db.collection("feedPosts").document(id)

        let newPlacesData = newPlaces.map { [
            "name": $0.name,
            "latitude": $0.coordinate.latitude,
            "longitude": $0.coordinate.longitude
        ]}

        // Get existing places, append new ones, and save
        ref.getDocument { snapshot, error in
            if let error = error {
                print("❌ Failed to fetch feed post: \(error.localizedDescription)")
                completion?(error)
                return
            }

            var existingPlaces = snapshot?["places"] as? [[String: Any]] ?? []
            existingPlaces.append(contentsOf: newPlacesData)

            ref.updateData(["places": existingPlaces]) { error in
                if let error = error {
                    print("❌ Failed to update feed post: \(error.localizedDescription)")
                } else {
                    print("✅ Feed post \(id) updated with \(newPlaces.count) new places")
                }
                completion?(error)
            }
        }
    }
    
    
    // MARK: - Change title
    
    func updateFeedPostTitle(id: String, newTitle: String, completion: ((Error?) -> Void)? = nil) {
        let ref = db.collection("feedPosts").document(id)
        ref.updateData(["title": newTitle]) { error in
            if let error = error {
                print("❌ Failed to update title: \(error.localizedDescription)")
            } else {
                print("✅ Feed post \(id) title updated to '\(newTitle)'")
            }
            completion?(error)
        }
    }

    // MARK: - Fetch Places
    func fetchPlaces(completion: @escaping ([Place]) -> Void) {
        db.collection("places").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching places: \(error.localizedDescription)")
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

    // MARK: - Add Place (directly to collection)
    func addPlace(_ place: Place, completion: ((Error?) -> Void)? = nil) {
        guard let userId = AuthManager.shared.currentUserId else { return }

        let ref = db.collection("places").document()
        let placeWithID = Place(id: ref.documentID, name: place.name, coordinate: place.coordinate)

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
    }
}
