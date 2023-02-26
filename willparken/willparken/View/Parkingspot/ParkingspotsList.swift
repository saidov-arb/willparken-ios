//
//  ParkingspotsList.swift
//  WillParken
//
//  Created by Arbi Said on 20.02.23.
//

import SwiftUI

struct ParkingspotsList: View {
    @EnvironmentObject var network: WPapi
    @State private var parkingspotDataTemplateOpen = false
    @State private var selectedParkingspot = Parkingspot(_id: "0", p_number: 0)
    
    var body: some View {
        
        List {
            ForEach(network.testParkingspots!, id: \.id) { iParkingspot in
                ParkingspotCard(parkingspot: iParkingspot)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(action: {
                            if let index = network.testParkingspots!.firstIndex(of: iParkingspot) {
                                network.testParkingspots!.remove(at: index)
                            }
                        }, label: {
                            Label("Delete", systemImage: "trash")
                        })
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            selectedParkingspot = iParkingspot
                            parkingspotDataTemplateOpen = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
            .listRowSeparator(Visibility.hidden)
            
            Rectangle()
                .foregroundColor(Color(.black).opacity(0))
                .frame(height: 50)
                .listRowSeparator(Visibility.hidden)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .sheet(isPresented: $parkingspotDataTemplateOpen) {
            ParkingspotEdit(parkingspot: $selectedParkingspot)
        }
        .toolbar {
            Button {
                selectedParkingspot = Parkingspot(_id: "0", p_number: 0)
                parkingspotDataTemplateOpen = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct ParkingspotsList_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotsList()
            .environmentObject(WPapi())
//        GeometryReader{ proxy in
//            let bottomSpace = proxy.safeAreaInsets.bottom
//            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
//                .environmentObject(Network())
//                .ignoresSafeArea(.all, edges: .bottom)
//        }
    }
}
