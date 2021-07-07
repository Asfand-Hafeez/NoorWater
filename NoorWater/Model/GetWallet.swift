//
//  GetWallet.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 13/06/2021.
//

import Foundation
struct GetWallet : Codable{
    var result: String
    var data: [Datum]
    var total, errorMsg: String
}

// MARK: - Datum
struct Datum : Codable {
    var amount, type, description, day: String
    var time: String
}
