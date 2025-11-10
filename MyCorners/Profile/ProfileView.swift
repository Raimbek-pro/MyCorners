//
//  ProfileView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var presenter = ProfilePostsPresenter()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let email = Auth.auth().currentUser?.email {
                    Text("Logged in as \(email)")
                        .font(.headline)
                } else {
                    Text("Not logged in")
                        .font(.headline)
                }

                List(presenter.myPosts, id: \.id) { post in
                    NavigationLink(destination: FeedPostMapView(post: post)) {
                        Text(post.title)
                    }
                }

                Spacer()

                Button(role: .destructive) {
                    authViewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("My Posts")
            .onAppear { presenter.loadMyPosts() }
        }
    }
}
