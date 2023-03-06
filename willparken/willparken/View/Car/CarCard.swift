//
//  CarCard.swift
//  WillParken
//
//  Created by Arbi Said on 28.02.23.
//

import SwiftUI

struct CarCard: View {
    var car: Car
    
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    Image(systemName: "car.fill")
                        .font(.largeTitle)
                        .padding([.leading,.trailing],5)
                }
                VStack (alignment: .leading,spacing: 5){
                    HStack{
                        Image(systemName: "car.circle")
                            .frame(minWidth: 25)
                        Text("\(car.c_brand)")
                            .textCase(.uppercase)
                        Divider().frame(height: 20).background(.blue)
                        Text("\(car.c_model)")
                            .textCase(.uppercase)
                    }
                    HStack{
                        Image(systemName: "123.rectangle")
                            .frame(minWidth: 25)
                        Text("\(car.c_licenceplate)")
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

struct CarCardTest: View {
    var body: some View{
        CarCard(car: Car.makeSampleCar()!)
    }
}

struct CarCard_Previews: PreviewProvider {
    static var previews: some View {
        CarCardTest()
    }
}
