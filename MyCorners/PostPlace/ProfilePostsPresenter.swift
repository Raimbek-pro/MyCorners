//
//  ProfilePostsPresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 10.11.2025.
//
import Combine
import FirebaseAuth

final class ProfilePostsPresenter: ObservableObject {
    private let interactor = FeedInteractor()
    @Published var myPosts: [FeedPost] = []
    
    func loadMyPosts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("❌ No current user logged in")
            return
        }
        
        print("🔹 Current user UID: \(currentUserId)") // log the UID
        
        interactor.fetchUserPosts(userId: currentUserId) { [weak self] posts in
            DispatchQueue.main.async {
                print("🔹 Fetched \(posts.count) posts for UID \(currentUserId)") // log number of posts
                self?.myPosts = posts
            }
        }
    }
}
