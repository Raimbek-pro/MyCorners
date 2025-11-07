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
    
    @Published var isLoggedIn: Bool = AuthManager.shared.currentUserId != nil
    
    @Published var places: [Place] = []
    private let interactor: PlaceListInteractor

    init(interactor: PlaceListInteractor) {
        self.interactor = interactor
    }

    
    func createFeedPost(title: String, places: [Place], completion: @escaping (String?) -> Void) {
        interactor.createFeedPost(title: title, places: places) { error, id in
            if error == nil { completion(id) }
            else { completion(nil) }
        }
    }

    func updateFeedPost(id: String, newPlaces: [Place]) {
        interactor.updateFeedPost(id: id, newPlaces: newPlaces)
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
    }}
