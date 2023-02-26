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
    var p_number: Int
    var p_availablefrom: String
    var p_availableuntil: String
    var p_priceperhour: String
    var pa_address: Address
    
    init(_id: String, p_number: Int) {
        self._id = _id
        self.p_number = p_number
        self.p_availablefrom = "01.01.2023"
        self.p_availableuntil = "31.01.2023"
        self.p_priceperhour = "7€"
        self.pa_address = Address()
    }
}
