//
//  GetOrder.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 13/06/2021.
//

import Foundation

struct GetOrder  : Codable{
    var inProcessOrdersCount, deliveredOrdersCount, cancelledOrdersCount, cancelledOppertunitiesCount: Int
    var inProcessOrdersList: [DeliveredOrdersList]
    var deliveredOrdersList: [DeliveredOrdersList]
    var cancelledOrdersList: [DeliveredOrdersList]
    
    var allOrders: [DeliveredOrdersList]
//    var oppertunitiesList: [DeliveredOrdersList]
}

// MARK: - DeliveredOrdersList
struct DeliveredOrdersList : Codable {
    var  orderDateTime, customerName: String
    var address, contact, reason, delivery: String
    var status: String
    var products: [Product]
    var paymentMethod, lat, lng: String
    var dsicount, customerId , orderNum: Int
    var paid: Double
    var orderStatus: String
}
// MARK: - Product
struct Product : Codable{
    var id: Int
    var image: String
    var name: String
    var qty, price: Int
}
