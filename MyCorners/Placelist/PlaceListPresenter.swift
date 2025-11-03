//
//  PlaceListPresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//


import Foundation
import SwiftUI
import Combine
final class PlaceListPresenter: ObservableObject {
    @Published var places: [Place] = []
    private let interactor: PlaceListInteractor

    init(interactor: PlaceListInteractor) {
        self.interactor = interactor
    }

    func loadPlaces() {
        places = interactor.fetchPlaces()
    }
}
