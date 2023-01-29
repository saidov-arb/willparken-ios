//
//  Car.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import Foundation

class Car: Identifiable, Decodable {
    var _id: String
    var c_brand: String
    var c_model: String
    var c_licenceplate: String
}

