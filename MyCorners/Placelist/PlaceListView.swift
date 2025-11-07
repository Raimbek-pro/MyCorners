//
//  PlaceListView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//
import Foundation

import SwiftUI

struct PlaceListView: View {
    @State var title: String                // <- editable now
    @StateObject var presenter: PlaceListPresenter
    var showCreateButton: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                // Editable title at the top
                TextField("Enter post title", text: $title)
                    .font(.title2)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)

                ZStack(alignment: .bottomTrailing) {
                    // Map showing all places
                    GoogleMapView(places: presenter.places, zoom: 12)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear { presenter.loadPlaces() }

                    if showCreateButton {
                        // Single "add post" button
                        NavigationLink(destination: {
                            let interactor = PostPlaceInteractor()
                            let postPresenter = PostPlacePresenter(interactor: interactor)

                            PostPlaceView(presenter: postPresenter) {
                                // When user finishes adding places, create feed post
                                if !postPresenter.places.isEmpty {
                                    presenter.createFeedPost(title: title, places: postPresenter.places)
                                }
                            }
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
            .navigationTitle(title) // syncs with editable title
        }
    }
}
