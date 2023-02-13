//
//  ParkingspotSlotView.swift
//  WillParken
//
//  Created by Arbi Said on 27.01.23.
//

import SwiftUI

struct ParkingspotSlotView: View {
    
    var spot: Parkingspot
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Parkplatznummer:")
                    .font(.headline)
                Text("\(spot.p_number)")
                    .font(.title)
            }
            HStack {
                Text("Verfügbar von:")
                    .font(.headline)
                Text("\(spot.p_availablefrom)")
                    .font(.title)
            }
            HStack {
                Text("Verfügbar bis:")
                    .font(.headline)
                Text("\(spot.p_availableuntil)")
                    .font(.title)
            }
            HStack {
                Text("Preis pro Stunde:")
                    .font(.headline)
                Text("\(spot.p_priceperhour)")
                    .font(.title)
            }
        }
        .padding()
    }
}

struct ParkingspotSlotViewTest: View{
    @State var spot: Parkingspot = Parkingspot(_id: "1", p_number: 1)
    var body: some View{
        ParkingspotSlotView(spot: spot)
    }
}

struct ParkingspotSlotView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotSlotViewTest()
    }
}
