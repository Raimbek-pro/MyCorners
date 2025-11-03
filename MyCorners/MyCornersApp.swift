//
//  MyCornersApp.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//

import SwiftUI

@main
struct MyCornersApp: App {
    var body: some Scene {
        WindowGroup {
            let interactor = PlaceListInteractor()
            let presenter = PlaceListPresenter(interactor: interactor)
           PlaceListView(presenter: presenter)
        }
    }
}
