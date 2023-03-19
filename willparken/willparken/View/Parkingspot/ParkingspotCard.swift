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
        HStack{
            VStack{
                Image(systemName: "parkingsign.circle.fill")
                    .font(.largeTitle)
                    .padding([.leading,.trailing],5)
                HStack{
                    Text(String(self.parkingspot.p_priceperhour))
                }
                .padding(5)
                .background(Color(red: 1, green: 0.95, blue: 0.7))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.95, blue: 0.2)).blur(radius: 2))
            }
            VStack (alignment: .leading,spacing: 5){
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                    Text("\(parkingspot.pa_address.a_zip)")
                    Divider().frame(height: 20).background(.blue)
                    Text("\(parkingspot.pa_address.a_street) \(parkingspot.pa_address.a_houseno)")
                    Divider().frame(height: 20).background(.blue)
                    Text("\(parkingspot.p_number)")
                }
                HStack{
                    Image(systemName: "clock")
                    Text("\( parkingspot.pt_availability.timefromAsString)")
                    Text("-")
                    Text("\( parkingspot.pt_availability.timeuntilAsString)")
                }
                HStack{
                    Image(systemName: "calendar")
                    Text("\( parkingspot.pt_availability.dayfromAsString)")
                    Text("-")
                    Text("\( parkingspot.pt_availability.dayuntilAsString)")
                }
                if parkingspot.pt_availability.t_weekday.count != 7 && parkingspot.pt_availability.t_weekday.count != 0 {
                    HStack{
                        Image(systemName: "7.square")
                        ForEach(parkingspot.pt_availability.t_weekday, id: \.self) { dayIndex in
                            WeekdayView(dayIndex: dayIndex-1)
                                .frame(maxWidth: 32)
                        }
                    }
                }
                if parkingspot.p_tags.count > 0 {
                    HStack{
                        Image(systemName: "tag")
                            .padding(.trailing,-3)
                        LazyVGrid(columns: [GridItem(.fixed(100)), GridItem(.fixed(100))]) {
                            ForEach(parkingspot.p_tags, id: \.self){ tag in
                                Text(tag)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 25)
                                    .background(Color(red: 0.85, green: 0.85, blue: 1))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.75, green: 0.75, blue: 1)).blur(radius: 2))
                            }
                        }
                    }
                    .padding(.top,1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
            .padding(.trailing,5)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(parkingspot.p_status == "active" ? Color.blue.opacity(0.03) : Color.red.opacity(0.03)))
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.blue)
        )
    }
}

struct ParkingspotCardTest: View {
    var body: some View{
        ParkingspotCard(parkingspot: Parkingspot.makeSampleParkingspot()!)
    }
}

struct ParkingspotCard_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotCardTest()
    }
}
