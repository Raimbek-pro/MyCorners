//
//  FeedEntity.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 07.11.2025.
//


import Foundation

struct FeedPost: Identifiable, Hashable {
    let id: String
    let title: String
    let places: [Place]
    var userId: String
    let userEmail: String
    static func == (lhs: FeedPost, rhs: FeedPost) -> Bool {
        // We only compare IDs, not the array of places
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
