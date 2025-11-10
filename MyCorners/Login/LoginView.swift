//
//  LoginView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 04.11.2025.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.title)
                .bold()

            Button("Sign in with Google") {
                guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
                authViewModel.signInWithGoogle(presenting: rootVC)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
