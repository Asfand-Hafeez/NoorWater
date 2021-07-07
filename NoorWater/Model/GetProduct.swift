//
//  GetProduct.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 29/05/2021.
//

import Foundation

struct GetProduct : Codable{

    var ProductsByCategory: [ProductsByCat]
}

// MARK: - ProductsByCategory
struct ProductsByCat : Codable {
    var category: String
    var products: [ResultData]
}

// MARK: - Result
struct ResultData : Codable {
    var id, productId, name, price: String
    var unit: String
    var image: String
}

struct CartQuantity : Codable {
    var cart : ResultData
    var quantity : Int
}

struct CustomerType: Codable {
    var result: [String]
}
