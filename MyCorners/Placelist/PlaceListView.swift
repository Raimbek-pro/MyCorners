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
        GoogleMapView(places: presenter.places, zoom: 12)
                    .edgesIgnoringSafeArea(.all)
        .onAppear { presenter.loadPlaces() }
    }
}
