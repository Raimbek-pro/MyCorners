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
    
    @State private var feedPostId: String? = nil
    
    //local tracking of places
    @State private var selectedPlaces: [Place] = []

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
                    .onChange(of: title) { newTitle in
                                         guard let id = feedPostId else { return }
                                         presenter.updateFeedPostTitle(id: id, newTitle: newTitle)
                                     }
                ZStack(alignment: .bottomTrailing) {
                    // Map showing all places
                    GoogleMapView(places: selectedPlaces, zoom: 12)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear { presenter.loadPlaces() }

                    if showCreateButton {
                        // Single "add post" button
                        NavigationLink(destination: {
                            let interactor = PostPlaceInteractor()
                            let postPresenter = PostPlacePresenter(interactor: interactor)

                            PostPlaceView(presenter: postPresenter) {
                                // When user finishes adding places, create feed post
                                let newPlaces = postPresenter.places
                                guard !newPlaces.isEmpty else { return }
                                selectedPlaces.append(contentsOf: postPresenter.places)
                                
                                if let existingId = feedPostId {
                                    // ✅ Update existing feed post
                                    presenter.updateFeedPost(
                                        id: existingId,
                                        newPlaces: newPlaces
                                    )
                                } else {
                                    // ✅ Create new feed post for the first time
                                    presenter.createFeedPost(title: title, places: newPlaces) { newId in
                                        feedPostId = newId
                                    }
                                }
//                                if !postPresenter.places.isEmpty {
//                                    presenter.createFeedPost(title: title, places: postPresenter.places)
//                                }
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
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
