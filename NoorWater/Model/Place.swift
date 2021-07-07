//
//  Place.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 27/05/2021.
//

import Foundation
struct ItemLocation: Codable {
    let name: String
    let longName: String
    let lat: Double
    let long: Double
    let placeId: String
}
struct PlaceData: Codable {
    let results : [PlaceResult]
}
struct PlaceResult: Codable {
    let formatted_address: String
    let geometry: PlaceGeometry
    let address_components: [AddressComponent]
    let place_id: String
}
struct PlaceGeometry: Codable {
    let location: PlaceLocation
}
struct PlaceLocation: Codable {
    let lat: Double
    let lng: Double
}
struct AddressComponent: Codable{
    let short_name: String
    let long_name: String
    let types: [String]
}
