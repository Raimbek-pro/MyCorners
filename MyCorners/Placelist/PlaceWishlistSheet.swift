//
//  PlaceWishlistSheet.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 16.11.2025.
//

import SwiftUI

struct PlaceWishlistSheet: View {
    @Binding var places: [Place]
    @Binding var completedPlaces: Set<String>

    var onZoom: (Place) -> Void
    
    var body: some View {
        VStack(spacing: 0) {

            // Small top grabber
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.top, 8)

            Text("Wishlist")
                .font(.title3)
                .bold()
                .padding(.top, 4)

            Divider()

            List {
                ForEach(places, id: \.id) { place in
                    HStack {
                        Button {
                            togglePlace(place)
                        } label: {
                            Image(systemName: completedPlaces.contains(place.id) ?
                                  "checkmark.circle.fill" : "circle")
                                .foregroundColor(.blue)
                        }

                        Text(place.name)
                            .strikethrough(completedPlaces.contains(place.id))
                            .animation(.easeInOut, value: completedPlaces)

                        Spacer()

                        Button {
                            onZoom(place)
                        } label: {
                            Image(systemName: "location.viewfinder")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        
        
    }
    
    private func togglePlace(_ place: Place) {
        if completedPlaces.contains(place.id) {
            completedPlaces.remove(place.id)
        } else {
            completedPlaces.insert(place.id)
        }
    }
}
