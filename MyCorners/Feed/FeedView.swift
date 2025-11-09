//
//  FeedView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 07.11.2025.
//

import SwiftUI
import MapKit

struct FeedView: View {
    @StateObject var presenter: FeedPresenter
    @State private var selectedPost: FeedPost?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List(presenter.posts, id: \.id) { post in
                    Button {
                        selectedPost = post
                    } label: {
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text("\(post.places.count) pinned places")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Created by: \(post.userEmail)") // or username if you fetch it separately
                                   .font(.subheadline)
                                   .foregroundColor(.blue)
                        }
                    }
                }
                .navigationDestination(item: $selectedPost) { post in
                    GoogleMapView(places: post.places, zoom: 12)
                        .navigationTitle(post.title)
                }
                .onAppear { presenter.loadFeed() }

                // 👇 Floating "create post" button
                // Floating "create post" button
                NavigationLink(destination: {
                    let interactor = PlaceListInteractor()
                    let postPresenter = PlaceListPresenter(interactor: interactor)
                    PlaceListView(title: "New post",presenter: postPresenter) // showCreateButton defaults true
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
                .padding()
            }
        }
    }
}
