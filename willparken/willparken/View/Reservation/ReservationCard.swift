//
//  ReservationCard.swift
//  WillParken
//
//  Created by Arbi Said on 07.03.23.
//

import SwiftUI

struct ReservationCard: View {
    var reservation: Reservation
    
    var body: some View {
        HStack{
            VStack{
                Image(systemName: "calendar.badge.clock")
                    .font(.largeTitle)
                    .padding([.leading,.trailing],5)
            }
            VStack (alignment: .leading,spacing: 5){
                HStack{
                    Image(systemName: "car.circle")
                    Text("\(reservation.rc_car)")
                        .textCase(.uppercase)
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
                HStack{
                    Button {
                        reservation.r_cancelled.toggle()
                    } label: {
                        Image(systemName: "7.square")
                    }

                    
                    if reservation.rt_timeframe.t_weekday.count == 7 || reservation.rt_timeframe.t_weekday.count == 0 {
                        WeekdayView(dayIndex: 7)
                    }else {
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
