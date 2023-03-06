//
//  Parkingspot.swift
//  WillParken
//
//  Created by Arbi Said on 27.01.23.
//

import Foundation

class Parkingspot: Identifiable, Codable, Equatable {
    static func == (lhs: Parkingspot, rhs: Parkingspot) -> Bool {
        return lhs._id == rhs._id
    }
    
    var _id: String
    var p_owner: String
    var p_number: String
    var p_priceperhour: Int
    var p_tags: [String]
    var p_deleteflag: Bool
    var pt_availability: Timeframe
    var pr_reservations: [Reservation]
    var pa_address: Address
    
    enum CodingKeys: String, CodingKey {
        case _id
        case p_owner
        case p_number
        case p_priceperhour
        case p_tags
        case p_deleteflag
        case pt_availability
        case pr_reservations
        case pa_address
    }
    
    init(_id: String, p_owner: String, p_number: String, p_priceperhour: Int, p_tags: [String], p_deleteflag: Bool, pt_availability: Timeframe, pr_reservations: [Reservation], pa_address: Address) {
        self._id = _id
        self.p_owner = p_owner
        self.p_number = p_number
        self.p_priceperhour = p_priceperhour
        self.p_tags = p_tags
        self.p_deleteflag = p_deleteflag
        self.pt_availability = pt_availability
        self.pr_reservations = pr_reservations
        self.pa_address = pa_address
    }
}

extension Parkingspot {
    static func makeSampleParkingspot() -> Parkingspot? {
        var parkingspot: Parkingspot? = nil
        if let path = Bundle.main.path(forResource: "SampleParkingspot", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                parkingspot = try JSONDecoder().decode(Parkingspot.self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return parkingspot
    }
}

extension Parkingspot {
    static func makeSampleParkingspotArray() -> [Parkingspot]?{
        var parkingspots: [Parkingspot]?
        if let path = Bundle.main.path(forResource: "SampleParkingspotArray", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                parkingspots = try JSONDecoder().decode([Parkingspot].self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return parkingspots
    }
}

extension Parkingspot {
    public func issameas(newParkingspot: Parkingspot) -> Bool {
        var issame = true
        
        if self.p_number != newParkingspot.p_number || self.p_priceperhour != newParkingspot.p_priceperhour || self.p_tags != newParkingspot.p_tags || self.pt_availability != newParkingspot.pt_availability || self.pa_address != newParkingspot.pa_address{
            issame = false
        }
        
        return issame
    }
}
