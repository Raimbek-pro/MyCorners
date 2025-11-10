//
//  AuthViewModel.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 04.11.2025.
//

import SwiftUI
import FirebaseAuth
import Combine
import GoogleSignIn

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = (user != nil)
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signInWithGoogle(presenting: UIViewController) {
        AuthManager.shared.signInWithGoogle(presenting: presenting) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isLoggedIn = true
                case .failure(let error):
                    print("❌ Google Sign-In failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            #if DEBUG
            print("❌ Firebase signOut failed: \(error.localizedDescription)")
            #endif
            isLoggedIn = Auth.auth().currentUser == nil
        }
    }
}

