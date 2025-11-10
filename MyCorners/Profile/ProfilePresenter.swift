//
//  ProfilePresenter.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 09.11.2025.
//

import Foundation
import Combine
final class ProfilePresenter: ObservableObject {
    private let interactor: ProfileInteractorProtocol
    
    @Published var userEmail: String?
    @Published var isLoggedOut = false
    
    init(interactor: ProfileInteractorProtocol) {
        self.interactor = interactor
        loadUserInfo()
    }
    
    func loadUserInfo() {
        userEmail = interactor.getCurrentUserEmail()
    }
    
    func signOut() {
        interactor.signOut()
        isLoggedOut = true
    }
}


