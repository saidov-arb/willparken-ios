//
//  Reservation.swift
//  WillParken
//
//  Created by Arbi Said on 26.02.23.
//

import Foundation

class Reservation: Identifiable, Codable {
    var _id: String
    var ru_user: String
    var rc_car: String
    var rt_timeframe: Timeframe
    var r_cancelled: Bool
    
    enum CodingKeys: String, CodingKey {
        case _id
        case ru_user
        case rc_car
        case rt_timeframe
        case r_cancelled
    }
}

extension Reservation {
    static func makeSampleReservation() -> Reservation? {
        var reservation: Reservation? = nil
        if let path = Bundle.main.path(forResource: "SampleReservation", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                reservation = try JSONDecoder().decode(Reservation.self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return reservation
    }
}
