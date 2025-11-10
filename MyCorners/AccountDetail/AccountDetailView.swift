//
//  AccountDetailView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 10.11.2025.
//
import SwiftUI
import FirebaseAuth
struct AccountDetailView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let email = Auth.auth().currentUser?.email {
                Text("Email: \(email)")
                    .font(.title2)
            } else {
                Text("No account info available")
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
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("Account")
    }
}
