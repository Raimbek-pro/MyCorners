//
//  PostPlaceView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 05.11.2025.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

struct PostPlaceView: View {
    @StateObject var presenter: PostPlacePresenter
    @Environment(\.dismiss) private var dismiss
    var onFinish: (() -> Void)? // runs when done adding places
    var body: some View {
        VStack(spacing: 16) {
            TextField("Place name", text: $presenter.placeName)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .onChange(of: presenter.placeName) { _ in
                        presenter.searchPlaces()
                    }
            if !presenter.predictions.isEmpty {
                List(presenter.predictions, id: \.placeID) { prediction in
                    Button(action: {
                        presenter.placeName = prediction.attributedPrimaryText.string
                        presenter.predictions.removeAll()
                        
                        // Get coordinate for the selected place
                        let placesClient = GMSPlacesClient.shared()
                        placesClient.fetchPlace(fromPlaceID: prediction.placeID,
                                                placeFields: [.coordinate, .name],
                                                sessionToken: nil) { place, error in
                            if let coord = place?.coordinate {
                                presenter.coordinate = coord
                            }
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(prediction.attributedPrimaryText.string)
                                .font(.headline)
                            Text(prediction.attributedSecondaryText?.string ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
            
            // Map view for picking location
            GoogleMapPickerView(coordinate: $presenter.coordinate)
                .frame(height: 300)
                .cornerRadius(12)
            
            Button {
                presenter.postPlace()
            } label: {
                if presenter.isPosting {
                    ProgressView()
                } else {
                    Text("Post Place")
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(presenter.placeName.isEmpty || presenter.coordinate == nil)
            
            Spacer()
        }
        .padding()
        .onChange(of: presenter.didPost) { posted in
            if posted { dismiss()
                onFinish?()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                TabBarManager.shared.hideTabBar()
            }
        }
        .onDisappear {
            TabBarManager.shared.showTabBar()
        }
        .navigationTitle("Add New Place")
        .toolbar(.hidden, for: .tabBar)
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
