//
//  MyCornersApp.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 02.11.2025.
//

import SwiftUI
import GoogleMaps


@main
struct MyCornersApp: App {
    
    init(){
        GMSServices.provideAPIKey("") //YOUR_API_KEY
        
    }
    var body: some Scene {
        WindowGroup {
            let interactor = PlaceListInteractor()
            let presenter = PlaceListPresenter(interactor: interactor)
           PlaceListView(presenter: presenter)
        }
    }
}
