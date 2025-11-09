//
//  MainTabView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//

import SwiftUI
struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            let interactor = FeedInteractor()
            let presenter = FeedPresenter(interactor: interactor)
            
            FeedView(presenter: presenter)
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
