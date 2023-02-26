//
//  Parkingspot.swift
//  WillParken
//
//  Created by Arbi Said on 27.01.23.
//

import Foundation

class Parkingspot: Identifiable, Decodable, Equatable {
    static func == (lhs: Parkingspot, rhs: Parkingspot) -> Bool {
        return lhs._id == rhs._id
    }
    
    var _id: String
    var p_owner: String
    var p_number: Int
    var p_priceperhour: String
    var p_tags: [String]
    var pt_availability: Timeframe
    var pr_reservations: [Reservation]
    var pa_address: Address
    
    init(_id: String, p_number: Int) {
        self._id = _id
        self.p_owner = "testid"
        self.p_number = p_number
        self.p_priceperhour = "7€"
        self.p_tags = ["ladestation","garage"]
        self.pt_availability = Timeframe(_id: "1")
        self.pr_reservations = [Reservation(_id: "1")]
        self.pa_address = Address()
    }
}
