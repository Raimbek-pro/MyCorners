//
//  PlaceListView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//

import Foundation
import SwiftUI
struct PlaceListView: View {
    @StateObject var presenter: PlaceListPresenter

    var body: some View {
        List(presenter.places) { place in
            Text(place.name)
        }
        .onAppear { presenter.loadPlaces() }
    }
}
