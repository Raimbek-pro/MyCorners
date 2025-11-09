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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let email = Auth.auth().currentUser?.email {
                    Text("Logged in as")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(email)
                        .font(.headline)
                } else {
                    Text("Not logged in")
                        .font(.headline)
                }

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

                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
