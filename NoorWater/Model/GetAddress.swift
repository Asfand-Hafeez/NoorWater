//
//  GetAddress.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 13/06/2021.
//

import Foundation

struct GetAddress : Codable {
    var result: [AddressData]
}

// MARK: - Result
struct AddressData : Codable {
    var addressId, type, userId: String
    var houseNo, address, lat: String
    var lng: String
    var teamId , street: String?
    
    
    

}
