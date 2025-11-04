//
//  AuthManager.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 04.11.2025.
//

import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(error!))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(error!))
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
}
