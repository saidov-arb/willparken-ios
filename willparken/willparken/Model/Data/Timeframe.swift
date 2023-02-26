//
//  Weekday.swift
//  WillParken
//
//  Created by Arbi Said on 22.02.23.
//

import Foundation

//public var weekdays = ["","Mo","Tu","We","Th","Fr","Sa","Su"]
//
//func weekdayNoToStr(weekdayno: Int) -> String{
//    return weekdayno < weekdays.count ? weekdays[weekdayno] : weekdays[0]
//}

class Timeframe: Identifiable, Decodable {
    var _id: String
    var t_weekday: [Int]
    var t_dayfrom: Int
    var t_dayuntil: Int
    var t_timefrom: Int
    var t_timeuntil: Int
    
    init(_id: String){
        self._id = _id
        self.t_weekday = [5,6,7]
        self.t_dayfrom = 20230101
        self.t_dayuntil = 20230228
        self.t_timefrom = 480
        self.t_timeuntil = 960
    }
}
