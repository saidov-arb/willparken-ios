//
//  Reservation.swift
//  WillParken
//
//  Created by Arbi Said on 26.02.23.
//

import Foundation

class Reservation: Identifiable, Decodable {
    var _id: String
    var ru_user: String
    var rc_car: Car
    var rt_timeframe: Timeframe
    
    init(_id: String){
        self._id = _id
        self.ru_user = "testid"
        self.rc_car = Car(_id: "1")
        self.rt_timeframe = Timeframe(_id: "1")
    }
}
