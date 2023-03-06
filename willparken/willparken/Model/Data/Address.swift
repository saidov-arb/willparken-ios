//
//  Address.swift
//  WillParken
//
//  Created by Arbi Said on 27.01.23.
//

import Foundation

class Address: Codable, Identifiable, Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.a_country == rhs.a_country &&
        lhs.a_city == rhs.a_city &&
        lhs.a_zip == rhs.a_zip &&
        lhs.a_street == rhs.a_street &&
        lhs.a_houseno == rhs.a_houseno &&
        lhs.a_longitude == rhs.a_longitude &&
        lhs.a_latitude == rhs.a_latitude
    }
    
    var a_country: String
    var a_city: String
    var a_zip: String
    var a_street: String
    var a_houseno: String
    var a_longitude: Double
    var a_latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case a_country
        case a_city
        case a_zip
        case a_street
        case a_houseno
        case a_longitude
        case a_latitude
    }
    
    init(a_country: String, a_city: String, a_zip: String, a_street: String, a_houseno: String, a_longitude: Double, a_latitude: Double) {
        self.a_country = a_country
        self.a_city = a_city
        self.a_zip = a_zip
        self.a_street = a_street
        self.a_houseno = a_houseno
        self.a_longitude = a_longitude
        self.a_latitude = a_latitude
    }
}

extension Address {
    static func makeSampleAddress() -> Address? {
        var address: Address? = nil
        if let path = Bundle.main.path(forResource: "SampleAddress", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                address = try JSONDecoder().decode(Address.self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return address
    }
}
