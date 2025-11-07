//
//  FeedPresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 07.11.2025.
//


import Combine
import UIKit
final class FeedPresenter: ObservableObject {
    private let interactor: FeedInteractor
    @Published var posts: [FeedPost] = []
    
    init(interactor: FeedInteractor) {
        self.interactor = interactor
    }
    
    func loadFeed() {
        interactor.fetchFeed { [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
            }
        }
    }
}
