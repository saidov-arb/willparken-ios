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
    var u_password: String
    var uc_cars: [Car]
    var up_parkingspots: [String]
}

