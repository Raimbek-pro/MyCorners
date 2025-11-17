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
    
    
    @State private var completedPlaces: Set<String> = []
    
    
    @State private var showSheet = true
    
    
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
    
    
    
    
    //MARK: - methods for markdowns
    
    func placeDone(_ place: Place) -> Bool {
        completedPlaces.contains(place.id)
    }
    
    func togglePlace(_ place: Place) {
        if completedPlaces.contains(place.id) {
            completedPlaces.remove(place.id)
        } else {
            completedPlaces.insert(place.id)
        }
    }
    
    
    func zoomTo(_ place: Place) {
        presenter.focusOnPlace(place)
    }
    
    
    //MARK: - body
    var body: some View {
        
        VStack {
            
            if showCreateButton{
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
            }
            
            ZStack(alignment: .bottomTrailing) {
                // Map showing all places
                GoogleMapView(places: selectedPlaces, zoom: 12, focusCoordinate: $presenter.focusCoordinate)
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
                //                    else{
                //                        .sheet(isPresented: $showSheet) {
                //                                  EmptyView()
                //                                  .presentationDetents([.fraction(0.1), .medium, .large])
                //                                  .presentationDragIndicator(.visible)
                //                                  .presentationBackgroundInteraction(.enabled)
                //                                  .interactiveDismissDisabled()
                //                              }
                
                
            }
            .onChange(of: presenter.places) { newPlaces in
                selectedPlaces = newPlaces
            }
            .navigationTitle(title) // syncs with editable title
            .toolbar(.hidden, for: .tabBar)
        }.sheet(isPresented: $showSheet) {
            PlaceWishlistSheet(
                places: $selectedPlaces,
                completedPlaces: $completedPlaces,
                onZoom: { place in
                    zoomTo(place)
                }
            )
            .presentationDetents([.fraction(0.15), .medium, .large])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
        .onAppear {
            TabBarManager.shared.hideTabBar()
        }
   
        
    }
    private func hideTabBar() {
          DispatchQueue.main.async {
              if let tabBarController = findTabBarController() {
                  tabBarController.tabBar.isHidden = true
              }
          }
      }
      
      private func showTabBar() {
          DispatchQueue.main.async {
              if let tabBarController = findTabBarController() {
                  tabBarController.tabBar.isHidden = false
              }
          }
      }
      
      private func findTabBarController() -> UITabBarController? {
          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
              return nil
          }
          
          if let tabBarController = findTabBarController(in: window.rootViewController) {
              return tabBarController
          }
          
          return nil
      }
      
      private func findTabBarController(in viewController: UIViewController?) -> UITabBarController? {
          guard let viewController = viewController else { return nil }
          
          if let tabBarController = viewController as? UITabBarController {
              return tabBarController
          }
          
          for childViewController in viewController.children {
              if let tabBarController = findTabBarController(in: childViewController) {
                  return tabBarController
              }
          }
          
          return nil
      }
}
