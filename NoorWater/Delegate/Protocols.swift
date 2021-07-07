//
//  Protocols.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 27/05/2021.
//

import Foundation
protocol Location {
    func setLocation(loc: ItemLocation)
}


protocol GetBackDeliveryDays {
    func backDays(loc: [SelectDays])
}

    

