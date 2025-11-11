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
    
    
    init(title: String,
          presenter: PlaceListPresenter,
          showCreateButton: Bool = true,
          feedPostId: String? = nil) {
         self._title = State(initialValue: title)
         self._presenter = StateObject(wrappedValue: presenter)
         self.showCreateButton = showCreateButton
         self._feedPostId = State(initialValue: feedPostId)
     }
    
    //local tracking of places
    @State private var selectedPlaces: [Place] = []

    var body: some View {
        NavigationStack {
            VStack {
                // Editable title at the top
                TextField("Enter post title", text: $title, onCommit: {
                    if let id = feedPostId {
                        // Post already exists → update its title
                        presenter.updateFeedPostTitle(id: id, newTitle: title)
                    } else {
                        // Post doesn’t exist yet → create one with empty places
                        presenter.createFeedPost(title: title, places: []) { newId in
                            feedPostId = newId
                        }
                    }
                })
                .font(.title2)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                ZStack(alignment: .bottomTrailing) {
                    // Map showing all places
                    GoogleMapView(places: selectedPlaces, zoom: 12)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            if let postId = feedPostId {
                                presenter.loadPostPlaces(postId: postId)
                            }
                        //    selectedPlaces = presenter.places
                        }

                    if showCreateButton {
                        // Single "add post" button
                        NavigationLink(destination: {
                            let interactor = PostPlaceInteractor()
                            let postPresenter = PostPlacePresenter(interactor: interactor)

                            PostPlaceView(presenter: postPresenter) {
                                let newPlaces = postPresenter.places
                                guard !newPlaces.isEmpty else { return }
                                selectedPlaces.append(contentsOf: postPresenter.places)

                                if let existingId = feedPostId {
                                    presenter.updateFeedPost(id: existingId, newPlaces: newPlaces) {
                                        // after update completes
                                        presenter.loadPostPlaces(postId: existingId)
                                    }
                                } else {
                                    presenter.createFeedPost(title: title, places: newPlaces) { newId in
                                        if let id = newId {
                                            feedPostId = id
                                            // immediately reflect new places
                                            selectedPlaces.append(contentsOf: newPlaces)
                                            presenter.loadPostPlaces(postId: id)
                                        }
                                    }
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
            .onChange(of: presenter.places) { newPlaces in
                   selectedPlaces = newPlaces
               }
            .navigationTitle(title) // syncs with editable title
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
