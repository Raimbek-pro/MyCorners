//
//  AuthManager.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 04.11.2025.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthManager {
    static let shared = AuthManager()
    private init() {}

    // MARK: - Google Sign-In
    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let signInResult = signInResult else {
                completion(.failure(NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Google sign-in result is nil"])) )
                return
            }

            // Extract tokens from the result
            guard let idToken = signInResult.user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])) )
                return
            }
            let accessToken = signInResult.user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if let user = result?.user {
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown sign-in error"])) )
                }
            }
        }
    }
    
    
    // MARK: - Sign Out
        func signOut() {
            try? Auth.auth().signOut()
        }

        // Optional: current user helper
        var currentUser: User? {
            Auth.auth().currentUser
        }
}
