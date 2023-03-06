//
//  Car.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import Foundation

class Car: Identifiable, Codable, Equatable {
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs._id == rhs._id
    }
    
    var _id: String
    var c_brand: String
    var c_model: String
    var c_licenceplate: String
    var c_isreserved: Bool
    
    enum CodingKeys: String, CodingKey {
        case _id
        case c_brand
        case c_model
        case c_licenceplate
        case c_isreserved
    }
    
    init(c_brand: String, c_model: String, c_licenceplate: String) {
        self._id = ""
        self.c_brand = c_brand
        self.c_model = c_model
        self.c_licenceplate = c_licenceplate
        self.c_isreserved = false
    }
}

extension Car {
    static func makeSampleCar() -> Car? {
        var car: Car? = nil
        if let path = Bundle.main.path(forResource: "SampleCar", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                car = try JSONDecoder().decode(Car.self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return car
    }
}

extension Car {
    public func issameas(newCar: Car) -> Bool {
        var issame = true
        
        if self.c_brand != newCar.c_brand ||
            self.c_model != newCar.c_model ||
            self.c_licenceplate != newCar.c_licenceplate {
            issame = false
        }
        
        return issame
    }
}
