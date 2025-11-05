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
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                GoogleMapView(places: presenter.places, zoom: 12)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear { presenter.loadPlaces() }
                
                NavigationLink(destination: {
                    let interactor = PostPlaceInteractor()
                    let postPresenter = PostPlacePresenter(interactor: interactor)
                    PostPlaceView(presenter: postPresenter)
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
        }
    }
}
