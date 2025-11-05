//
//  PostPlacePresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 05.11.2025.
//

import Foundation
import CoreLocation
import Combine
final class PostPlacePresenter: ObservableObject {
    @Published var placeName: String = ""
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var isPosting: Bool = false
    @Published var didPost: Bool = false
    
    private let interactor: PostPlaceInteractor
    
    init(interactor: PostPlaceInteractor) {
        self.interactor = interactor
    }
    
    func postPlace() {
        guard let coordinate = coordinate, !placeName.isEmpty else { return }
        isPosting = true
        let newPlace = NewPlace(name: placeName, coordinate: coordinate)
        
        interactor.addPlace(newPlace) { [weak self] error in
            DispatchQueue.main.async {
                self?.isPosting = false
                self?.didPost = (error == nil)
            }
        }
    }
}
