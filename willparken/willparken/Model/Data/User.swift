//
//  User.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//
//  https://designcode.io/swiftui-advanced-handbook-http-request

//  Identifiable means that each item has a unique ID.
//  Decodable means that it can be decoded - for example,
//  we can transform a JSON object into this data model.

import Foundation

class User: Identifiable, Decodable, ObservableObject {
    var _id: String
    var u_email: String
    var u_username: String
    var u_firstname: String
    var u_lastname: String
    var uc_cars: [Car]
    var up_parkingspots: [String]
    var ur_reservations: [String]
    
    init() {
        self._id = "testid"
        self.u_email = "test@willparken.wp"
        self.u_username = "testusername"
        self.u_firstname = "testfirstname"
        self.u_lastname = "testlastname"
        self.uc_cars = [Car(_id: "1"),Car(_id: "2")]
        self.up_parkingspots = ["1","2","3"]
        self.ur_reservations = ["1"]
    }
}

