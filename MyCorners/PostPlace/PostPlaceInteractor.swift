//
//  PostPlaceInteractor.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 05.11.2025.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation
import CoreLocation

final class PostPlaceInteractor {
    private let db = Firestore.firestore()
    
    func addPlace(_ place: NewPlace, completion: @escaping (Error?) -> Void) {
        guard let userId = AuthManager.shared.currentUserId else {
            completion(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        let ref = db.collection("places").document()
        ref.setData([
            "userId": userId,
            "name": place.name,
            "latitude": place.coordinate.latitude,
            "longitude": place.coordinate.longitude
        ]) { error in
            if let error = error {
                print("❌ Failed to add place: \(error.localizedDescription)")
            } else {
                print("✅ Place added with ID: \(ref.documentID)")
            }
            completion(error)
        }
    }
}
