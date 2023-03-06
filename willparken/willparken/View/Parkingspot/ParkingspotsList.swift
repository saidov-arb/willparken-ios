//
//  ParkingspotsList.swift
//  WillParken
//
//  Created by Arbi Said on 20.02.23.
//

import SwiftUI

struct ParkingspotsList: View {
    @EnvironmentObject var wpvm: WPViewModel
    @State private var parkingspotCreateOpen = false
    @State private var selectedParkingspot: Parkingspot?
    
    var body: some View {
        List {
            if let parkingspots = wpvm.currentParkingspots{
                ForEach(parkingspots) { iParkingspot in
                    
                    ParkingspotCard(parkingspot: iParkingspot)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                selectedParkingspot = iParkingspot
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        wpvm.deleteParkingspot(parkingspotid: parkingspots[index]._id) { msg in
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
                .frame(height: 50)
                .listRowSeparator(Visibility.hidden)
        }
        .refreshable {
            wpvm.loadParkingspotsFromUser()
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .sheet(item: $selectedParkingspot) { parkingspot in
            ParkingspotEdit(parkingspot: parkingspot)
                .environmentObject(wpvm)
        }
        .sheet(isPresented: $parkingspotCreateOpen){
            ParkingspotEdit(parkingspot: nil)
                .environmentObject(wpvm)
        }
        .toolbar {
            Button {
                parkingspotCreateOpen = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct ParkingspotsList_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotsList()
            .environmentObject(WPViewModel())
//        GeometryReader{ proxy in
//            let bottomSpace = proxy.safeAreaInsets.bottom
//            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
//                .environmentObject(Network())
//                .ignoresSafeArea(.all, edges: .bottom)
//        }
    }
}
