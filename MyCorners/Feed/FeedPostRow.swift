//
//  FeedPostRow.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//
import SwiftUI
struct FeedPostRow: View {
    let post: FeedPost
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
            Text("\(post.places.count) pinned places")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Created by: \(post.userEmail)")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }
}
