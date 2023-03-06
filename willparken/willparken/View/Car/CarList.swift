//
//  CarList.swift
//  WillParken
//
//  Created by Arbi Said on 28.02.23.
//

import SwiftUI

struct CarList: View {
    @EnvironmentObject var wpapi: WPapi
    @State private var carCreateOpen = false
    @State private var selectedCar: Car?
    
    var body: some View {
        List {
            ForEach(wpapi.currentUser!.uc_cars, id: \.id) { iCar in
                
                CarCard(car: iCar)
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            selectedCar = iCar
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
            .onDelete(perform: { indexSet in
                wpapi.currentUser!.uc_cars.remove(atOffsets: indexSet)
            })
            .listRowSeparator(Visibility.hidden)
            
            Rectangle()
                .foregroundColor(Color(.black).opacity(0))
                .frame(height: 50)
                .listRowSeparator(Visibility.hidden)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .sheet(item: $selectedCar) { car in
            CarEdit(car: car)
                .environmentObject(wpapi)
        }
        .sheet(isPresented: $carCreateOpen) {
            CarEdit(car: nil)
                .environmentObject(wpapi)
        }
        .toolbar {
            Button {
                carCreateOpen = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct CarList_Previews: PreviewProvider {
    static var previews: some View {
        CarList()
            .environmentObject(WPapi())
    }
}
