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
    
    
    @State private var showMap = false
    @State private var mapPlaces: [Place] = []
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List(presenter.posts, id: \.id) { post in
                    Button { selectedPost = post } label: {
                        FeedPostRow(post: post)
                    }
                }
                .navigationDestination(item: $selectedPost) { post in
                    
                    
                    let interactor = PlaceListInteractor()
                    let presenter = PlaceListPresenter(interactor: interactor)
                //    FeedPostMapView(post: post)
                    if post.isOwnedByCurrentUser {
                          // Editable module
                      
                            PlaceListView(
                                title: post.title,
                                presenter: presenter,
                                showCreateButton: true,
                                feedPostId: post.id // pass the existing post ID
                            ).toolbar(.hidden, for: .tabBar)
                        
                      } else {
                          // Read-only for others
                          PlaceListView(
                              title: post.title,
                              presenter: presenter,
                              showCreateButton: false,
                              feedPostId: post.id // pass the existing post ID
                          ).toolbar(.hidden, for: .tabBar)
                      }
                }
              
                .onAppear { presenter.loadFeed() }

                // 👇 Floating "create post" button
                // Floating "create post" button
                CreatePostButton()
            }
           
        }
        
    }
}
