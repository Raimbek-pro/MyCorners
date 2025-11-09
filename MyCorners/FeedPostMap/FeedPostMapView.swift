//
//  FeedPostMapView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//
import SwiftUI
struct FeedPostMapView: View {
    let post: FeedPost
    
    var body: some View {
        GoogleMapView(places: post.places, zoom: 12)
            .navigationTitle(post.title)
            .navigationBarTitleDisplayMode(.inline)
                       .toolbar(.hidden, for: .tabBar) // hides tab bar only here
    }
}
