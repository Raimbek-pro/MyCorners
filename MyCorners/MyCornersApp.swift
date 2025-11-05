//
//  MyCornersApp.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//

import SwiftUI
import GoogleMaps
import FirebaseCore
import FirebaseAuth

@main
struct MyCornersApp: App {
    
    @StateObject private var authViewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
        GMSServices.provideAPIKey("") //YOUR_API_KEY
        
        if let user = Auth.auth().currentUser {
               print("✅ User is logged in with UID: \(user.uid)")
           } else {
               print("⚠️ No user logged in")
           }
        
    }
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                let interactor = PlaceListInteractor()
                let presenter = PlaceListPresenter(interactor: interactor)
                PlaceListView(presenter: presenter)
            }else{
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}
