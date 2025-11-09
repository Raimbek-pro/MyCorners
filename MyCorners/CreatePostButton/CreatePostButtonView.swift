//
//  CreatePostButtonView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//
import SwiftUI
struct CreatePostButton: View {
    var body: some View {
        NavigationLink(destination: {
            let interactor = PlaceListInteractor()
            let postPresenter = PlaceListPresenter(interactor: interactor)
            PlaceListView(title: "New post", presenter: postPresenter)
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
        .padding()
    }
}
