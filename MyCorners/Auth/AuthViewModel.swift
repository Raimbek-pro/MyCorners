//
//  AuthViewModel.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 04.11.2025.
//

import Foundation
import FirebaseAuth
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = AuthManager.shared.currentUserId != nil
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        // listen for real-time auth changes
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = (user != nil)
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signIn(email: String, password: String) {
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                case .failure(let error):
                    print("❌ Login failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func signUp(email: String, password: String) {
        AuthManager.shared.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                case .failure(let error):
                    print("❌ Sign up failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func signOut() {
        AuthManager.shared.signOut()
        isLoggedIn = false
    }
}
