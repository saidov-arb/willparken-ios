//
//  Address.swift
//  WillParken
//
//  Created by Arbi Said on 27.01.23.
//

import Foundation

class Address: Decodable, Identifiable {
    var _id: String
    var a_country: String
    var a_city: String
    var a_zip: String
    var a_address1: String
    var a_address2: String
    
    init() {
        self._id = "1"
        self.a_country = "Austria"
        self.a_city = "Wels"
        self.a_zip = "4600"
        self.a_address1 = "Fischergasse 30"
        self.a_address2 = ""
    }
}
