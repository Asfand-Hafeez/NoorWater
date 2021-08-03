//
//  UserModel.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 18/05/2021.
//

import Foundation
// MARK: - UserModel
struct UserModel : Codable {
    var result, module, msg, page: String?
    var userDetails: UserDetails?
    var haveAddress: String?
    var userId: String?
    var errorMsg: String?
    var CurrAddresses: [AddressData]?
}

// MARK: - UserDetails
struct UserDetails : Codable{
    var id, name, profileImage, password: String
    var adminType, cityId, creditLimit, areaId: String
    var houseNo, land, street: String
//    var address: NSNull
    var customerAddress: UserAddress?
    var customerAddressLat, customerAddressLng, email, trn: String
    var deliveryRequired, customerGrpName: String
//    var customerGrp: NSNull
    

    var contactNos, username, howToKnow, describe: String
    var remove, update, buildingNo: String
}



struct UserAddress: Codable {
    
    let addressId: String
    let houseNo: String
//    let street: String?
    let address: String
    let lat: String
    let lng: String
    
}
