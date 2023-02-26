//
//  ParkingspotCard.swift
//  WillParken
//
//  Created by Arbi Said on 20.02.23.
//

import SwiftUI

struct ParkingspotCard: View {
    var parkingspot: Parkingspot
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    Image(systemName: "parkingsign.circle.fill")
                        .font(.largeTitle)
                        .padding([.leading,.trailing],5)
                    HStack{
                        Text("10€")
                    }
                    .padding(5)
                    .background(Color(red: 1, green: 0.95, blue: 0.7))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.95, blue: 0.2)).blur(radius: 2))
                }
                //  MARK: What if weekday is unknown? Or some information is irrelevant?
                VStack (alignment: .leading,spacing: 5){
                    HStack{
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(parkingspot.pa_address.a_zip)")
                        Divider().frame(height: 20).background(.blue)
                        Text("\(parkingspot.pa_address.a_address1)")
                        Divider().frame(height: 20).background(.blue)
                        Text("\(parkingspot.p_number)")
                    }
                    HStack{
                        Image(systemName: "clock")
                        Text("08:00")
                        Text("-")
                        Text("16:00")
                    }
                    HStack{
                        Image(systemName: "calendar")
                        Text("\(parkingspot.p_availablefrom)")
                        Text("-")
                        Text("\(parkingspot.p_availableuntil)")
                    }
                    HStack{
                        Image(systemName: "7.square")
                        let weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                        ForEach(weekdays, id: \.self) { day in
                            Text(day)
                                .frame(width: 30,height: 25)
                                .background(Color(red: 0.85, green: 0.85, blue: 1))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.75, green: 0.75, blue: 1)).blur(radius: 2))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .padding(.trailing,5)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color.blue.opacity(0.03)))
            .overlay(
                RoundedRectangle(cornerRadius: 12).stroke(.blue)
            )
        }
    }
}

struct ParkingspotCardTest: View {
    var parkingspot = Parkingspot(_id: "1", p_number: 1)
    var body: some View{
        ParkingspotCard(parkingspot: parkingspot)
    }
}

struct ParkingspotCard_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotCardTest()
    }
}
