//
//  PostPlacePresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 05.11.2025.
//

import Foundation
import CoreLocation
import Combine
import GooglePlaces
final class PostPlacePresenter: ObservableObject {
    @Published var placeName: String = ""
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var isPosting: Bool = false
    @Published var didPost: Bool = false
    
    @Published var places: [Place] = []
    @Published var predictions: [GMSAutocompletePrediction] = []
    
    
    
    private let interactor: PostPlaceInteractor
    
    init(interactor: PostPlaceInteractor) {
        self.interactor = interactor
    }
    
    
    func searchPlaces() {
        guard !placeName.isEmpty else {
            predictions = []
            return
        }

        searchPlace(query: placeName) { [weak self] results in
            DispatchQueue.main.async {
                self?.predictions = results
            }
        }
    }
    
    
    func postPlace() {
      
        guard let coordinate = coordinate, !placeName.isEmpty else { return }
        isPosting = true
        let newPlace = Place(id: UUID().uuidString, name: placeName, coordinate: coordinate)
        
        interactor.addPlace(newPlace) { [weak self] error in
            DispatchQueue.main.async {
                self?.isPosting = false
                if error == nil{
                    self?.places.append(newPlace)
                    self?.didPost = true
                }
            }
        }
    }
}
