//
//  ProfileInteractor.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//

import Foundation
import FirebaseAuth

protocol ProfileInteractorProtocol {
    func getCurrentUserEmail() -> String?
    func signOut()
}

final class ProfileInteractor: ProfileInteractorProtocol {
    private let authManager = AuthManager.shared
    
    func getCurrentUserEmail() -> String? {
        Auth.auth().currentUser?.email
    }
    
    func signOut() {
        authManager.signOut()
    }
}
