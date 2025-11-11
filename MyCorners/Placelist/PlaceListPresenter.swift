//
//  PlaceListPresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//


import Foundation
import SwiftUI
import Combine
internal import _LocationEssentials
final class PlaceListPresenter: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    
    @Published var places: [Place] = []
    private let interactor: PlaceListInteractor
    
    init(interactor: PlaceListInteractor) {
        self.interactor = interactor
        refreshAuthState()
    }
    
    /// Refreshes the authentication state.
    /// TODO: Replace the body with the correct logic from your AuthManager (e.g., `AuthManager.shared.isAuthenticated()` or similar).
    func refreshAuthState() {
        // If your AuthManager exposes an `isLoggedIn` or `isAuthenticated` boolean, use it here.
        // Example:
        // self.isLoggedIn = AuthManager.shared.isLoggedIn
        // For now, default to whether a token/user session exists if available, otherwise keep false.
        // self.isLoggedIn = AuthManager.shared.session != nil
    }
    
    func createFeedPost(title: String, places: [Place], completion: @escaping (String?) -> Void) {
        interactor.createFeedPost(title: title, places: places) { error, id in
            if error == nil { completion(id) }
            else { completion(nil) }
        }
    }
    
    
    func updateFeedPostTitle(id: String, newTitle: String) {
        interactor.updateFeedPostTitle(id: id, newTitle: newTitle)
    }
    
    
    
    func updateFeedPost(id: String, newPlaces: [Place], completion: (() -> Void)? = nil) {
        interactor.updateFeedPost(id: id, newPlaces: newPlaces) { error in
            if error == nil {
                completion?()
            }
        }
    }
    func loadPlaces() {
        interactor.fetchPlaces { [weak self] places in
            DispatchQueue.main.async {
                self?.places = places
            }
        }
    }
    
    func addPlace(name: String, latitude: Double, longitude: Double) {
        let newPlace = Place(
            id: "", // temporary, Firestore will assign a real ID
            name: name,
            coordinate: .init(latitude: latitude, longitude: longitude)
        )
        
        interactor.addPlace(newPlace) { [weak self] error in
            if error == nil {
                self?.loadPlaces()
            }
        }
    }
    
    
    func loadPostPlaces(postId: String) {
        interactor.fetchFeedPostById(postId: postId) { [weak self] places in
            DispatchQueue.main.async {
                self?.places = places
            }
        }
    }
    
}
