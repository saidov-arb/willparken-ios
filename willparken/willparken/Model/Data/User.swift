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

class User: Identifiable, Codable, ObservableObject {
    var _id: String
    var u_email: String
    var u_username: String
    var u_firstname: String
    var u_lastname: String
    var u_balance: Int
    var uc_cars: [Car]
    var up_parkingspots: [String]
    var ur_reservations: [ur_reservations]
    
    struct ur_reservations: Codable {
        var parkingspotid: String
        var reservationid: String
    }
    
    enum CodingKeys: String, CodingKey {
        case _id
        case u_email
        case u_username
        case u_firstname
        case u_lastname
        case u_balance
        case uc_cars
        case up_parkingspots
        case ur_reservations
    }
}

extension User {
    static func makeSampleUser() -> User? {
        var user: User? = nil
        if let path = Bundle.main.path(forResource: "SampleUser", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                user = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return user
    }
}
