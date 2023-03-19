//
//  ReservationCard.swift
//  WillParken
//
//  Created by Arbi Said on 07.03.23.
//

import SwiftUI

struct ReservationCard: View {
    var reservation: Reservation
    var car: Car?
    
    var body: some View {
        HStack{
            VStack{
                Image(systemName: "calendar.badge.clock")
                    .font(.largeTitle)
                    .padding([.leading,.trailing],5)
            }
            VStack (alignment: .leading,spacing: 5){
                if let car = car {
                    HStack{
                        Image(systemName: "car.circle")
                        Text("\(car.c_brand)")
                            .textCase(.uppercase)
                        Divider().frame(height: 20).background(.blue)
                        Text("\(car.c_model)")
                            .textCase(.uppercase)
                        Divider().frame(height: 20).background(.blue)
                        Text("\(car.c_licenceplate)")
                    }
                }
                HStack{
                    Image(systemName: "clock")
                    Text("\( reservation.rt_timeframe.timefromAsString)")
                    Text("-")
                    Text("\( reservation.rt_timeframe.timeuntilAsString)")
                }
                HStack{
                    Image(systemName: "calendar")
                    Text("\( reservation.rt_timeframe.dayfromAsString)")
                    Text("-")
                    Text("\( reservation.rt_timeframe.dayuntilAsString)")
                }
                if reservation.rt_timeframe.t_weekday.count != 0 && reservation.rt_timeframe.t_weekday.count != 7{
                    HStack{
                        Image(systemName: "7.square")
                        ForEach(reservation.rt_timeframe.t_weekday, id: \.self) { dayIndex in
                            WeekdayView(dayIndex: dayIndex-1)
                                .frame(maxWidth: 32)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
            .padding(.trailing,5)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(reservation.r_cancelled ? Color.red.opacity(0.03) : Color.blue.opacity(0.03)))
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.blue)
        )
    }
}

struct ReservationCard_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCard(reservation: Reservation.makeSampleReservation()!)
    }
}
