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
            if posted { dismiss() }
        }
        .navigationTitle("Add New Place")
    }
}
