//
//  PostPlaceView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 05.11.2025.
//

import SwiftUI
import CoreLocation

struct PostPlaceView: View {
    @StateObject var presenter: PostPlacePresenter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Place name", text: $presenter.placeName)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button("Use Current Location") {
                // test coords for now
                presenter.coordinate = CLLocationCoordinate2D(latitude: 43.238949, longitude: 76.889709)
            }
            
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
            .disabled(presenter.placeName.isEmpty)
            
            Spacer()
        }
        .padding()
        .onChange(of: presenter.didPost) { posted in
            if posted { dismiss() }
        }
        .navigationTitle("Add New Place")
    }
}
