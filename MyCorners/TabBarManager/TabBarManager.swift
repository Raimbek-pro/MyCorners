//
//  TabBarManager.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 16.11.2025.
//

// TabBarManager.swift
import SwiftUI
import Combine
class TabBarManager: ObservableObject {
    static let shared = TabBarManager()
    
    private init() {}
    
    func hideTabBar() {
        DispatchQueue.main.async {
            if let tabBarController = self.findTabBarController() {
                tabBarController.tabBar.isHidden = true
            }
        }
    }
    
    func showTabBar() {
        DispatchQueue.main.async {
            if let tabBarController = self.findTabBarController() {
                tabBarController.tabBar.isHidden = false
            }
        }
    }
    
    private func findTabBarController() -> UITabBarController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        return findTabBarController(in: window.rootViewController)
    }
    
    private func findTabBarController(in viewController: UIViewController?) -> UITabBarController? {
        guard let viewController = viewController else { return nil }
        
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController
        }
        
        for childViewController in viewController.children {
            if let tabBarController = findTabBarController(in: childViewController) {
                return tabBarController
            }
        }
        
        if let presentedViewController = viewController.presentedViewController {
            return findTabBarController(in: presentedViewController)
        }
        
        return nil
    }
}
