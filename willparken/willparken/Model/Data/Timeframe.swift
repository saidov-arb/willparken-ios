//
//  Weekday.swift
//  WillParken
//
//  Created by Arbi Said on 22.02.23.
//

import Foundation

class Timeframe: Identifiable, Codable, Equatable {
    static func == (lhs: Timeframe, rhs: Timeframe) -> Bool {
        return lhs.t_weekday == rhs.t_weekday && lhs.t_dayfrom == rhs.t_dayfrom && lhs.t_dayuntil == rhs.t_dayuntil && lhs.t_timefrom == rhs.t_timefrom && lhs.t_timeuntil == rhs.t_timeuntil
    }
    
    var t_weekday: [Int]
    var t_dayfrom: Int
    var t_dayuntil: Int
    var t_timefrom: Int
    var t_timeuntil: Int
    
    enum CodingKeys: String, CodingKey {
        case t_weekday
        case t_dayfrom
        case t_dayuntil
        case t_timefrom
        case t_timeuntil
    }
    
    init(t_weekday: [Int], t_dayfrom: Int, t_dayuntil: Int, t_timefrom: Int, t_timeuntil: Int) {
        self.t_weekday = t_weekday
        self.t_dayfrom = t_dayfrom
        self.t_dayuntil = t_dayuntil
        self.t_timefrom = t_timefrom
        self.t_timeuntil = t_timeuntil
    }
    
    init(t_weekday: [Int], t_dayfrom: Date, t_dayuntil: Date, t_timefrom: Date, t_timeuntil: Date){
        self.t_weekday = t_weekday
        self.t_dayfrom = 0
        self.t_dayuntil = 0
        self.t_timefrom = 0
        self.t_timeuntil = 0
        self.t_dayfrom = morphDayDateToInt(dateAsDate: t_dayfrom)
        self.t_dayuntil = morphDayDateToInt(dateAsDate: t_dayuntil)
        self.t_timefrom = morphTimeDateToInt(timeAsDate: t_timefrom)
        self.t_timeuntil = morphTimeDateToInt(timeAsDate: t_timeuntil)
    }
}

extension Timeframe {
    static func makeSampleTimeframe() -> Timeframe? {
        var timeframe: Timeframe? = nil
        if let path = Bundle.main.path(forResource: "SampleTimeframe", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                timeframe = try JSONDecoder().decode(Timeframe.self, from: data)
            } catch {
                print("Error reading JSON file:", error)
            }
        }
        return timeframe
    }
}

extension Timeframe {
    private func morphDayIntToDate(dateAsInt: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        guard let date = dateFormatter.date(from: String(dateAsInt)) else { fatalError("Incorrect Date Format. Should be: yyyyMMdd") }
        return date
    }
    
    private func morphDayDateToString(dateAsDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: dateAsDate)
    }
    
    private func morphDayDateToInt(dateAsDate: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return Int(dateFormatter.string(from: dateAsDate))!
    }
    
    public var dayfromAsDate: Date {
        return morphDayIntToDate(dateAsInt: t_dayfrom)
    }
    
    public var dayfromAsString: String {
        return morphDayDateToString(dateAsDate: dayfromAsDate)
    }
    
    public var dayuntilAsDate: Date {
        return morphDayIntToDate(dateAsInt: t_dayuntil)
    }
    
    public var dayuntilAsString: String {
        return morphDayDateToString(dateAsDate: dayuntilAsDate)
    }
}
 
extension Timeframe {
    private func morphTimeIntToDate(timeAsInt: Int) -> Date{
        let time = DateComponents(hour: timeAsInt / 60, minute: timeAsInt % 60)
        guard let date = Calendar.current.date(from: time) else { fatalError("Time is not an Int.") }
        return date
    }
    
    private func morphTimeDateToString(timeAsDate: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timeAsDate)
    }
    
    private func morphTimeDateToInt(timeAsDate: Date) -> Int{
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: timeAsDate)
        let minutes = calendar.component(.minute, from: timeAsDate)
        return hours * 60 + minutes
    }
    
    public var timefromAsDate: Date {
        return morphTimeIntToDate(timeAsInt: t_timefrom)
    }
    
    public var timefromAsString: String {
        return morphTimeDateToString(timeAsDate: timefromAsDate)
    }
    
    public var timeuntilAsDate: Date {
        return morphTimeIntToDate(timeAsInt: t_timeuntil)
    }
    
    public var timeuntilAsString: String {
        return morphTimeDateToString(timeAsDate: timeuntilAsDate)
    }
}
