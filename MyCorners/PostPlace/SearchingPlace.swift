//
//  SearchingPlace.swift
//  MyCorners
//
//  Created by Райымбек Омаров on 06.11.2025.
//

import GooglePlaces

func searchPlace(query: String, completion: @escaping ([GMSAutocompletePrediction]) -> Void) {
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment // or .geocode
    
    GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
        completion(results ?? [])
    }
}


