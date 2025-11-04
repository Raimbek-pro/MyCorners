//
//  LoginView.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 04.11.2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUp ? "Create Account" : "Sign In")
                .font(.title)
                .bold()

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button(isSignUp ? "Sign Up" : "Sign In") {
                if isSignUp {
                    authViewModel.signUp(email: email, password: password)
                } else {
                    authViewModel.signIn(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)

            Button(isSignUp ? "Already have an account? Sign In" : "Don’t have an account? Sign Up") {
                isSignUp.toggle()
            }
            .foregroundColor(.gray)
            .font(.footnote)
        }
        .padding()
    }
}
