//
//  CarList.swift
//  WillParken
//
//  Created by Arbi Said on 28.02.23.
//

import SwiftUI

struct CarList: View {
    @EnvironmentObject var wpvm: WPViewModel
    @State private var carCreateOpen = false
    @State private var selectedCar: Car?
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        List {
            if let cars = wpvm.currentUser?.uc_cars{
                ForEach(cars) { iCar in
                    
                    CarCard(car: iCar)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                selectedCar = iCar
                            } label: {
                                Label("Bearbeiten", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        guard !cars[index].c_isreserved else {
                            errorMsg = "Fahrzeug wird für eine Reservierung benötigt."
                            isError = true
                            return
                        }
                        wpvm.deleteCar(carid: cars[index]._id) { msg in
                            if let msg = msg {
                                print(msg)
                            }
                        }
                    }
                })
                .listRowSeparator(Visibility.hidden)
            }
            
            Rectangle()
                .foregroundColor(Color(.black).opacity(0))
                .frame(height: 80)
                .listRowSeparator(Visibility.hidden)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .sheet(item: $selectedCar) { car in
            CarEdit(car: car)
                .environmentObject(wpvm)
        }
        .sheet(isPresented: $carCreateOpen) {
            CarEdit(car: nil)
                .environmentObject(wpvm)
        }
        .toolbar {
            Button {
                carCreateOpen = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
    }
}

struct CarList_Previews: PreviewProvider {
    static var previews: some View {
        CarList()
            .environmentObject(WPViewModel())
    }
}
