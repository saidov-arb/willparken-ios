//
//  ParkingspotsList.swift
//  WillParken
//
//  Created by Arbi Said on 20.02.23.
//

import SwiftUI

struct ParkingspotList: View {
    @EnvironmentObject var wpvm: WPViewModel
    @State private var parkingspotCreateOpen = false
    @State private var selectedParkingspotToEdit: Parkingspot?
    @State private var selectedParkingspotToViewReservations: Parkingspot?
    
    var body: some View {
        List {
            if let parkingspots = wpvm.currentParkingspots{
                ForEach(parkingspots) { iParkingspot in
                    ParkingspotCard(parkingspot: iParkingspot)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                selectedParkingspotToEdit = iParkingspot
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                selectedParkingspotToViewReservations = iParkingspot
                            } label: {
                                Label("Reservations", systemImage: "calendar.badge.clock")
                            }
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
        .sheet(item: $selectedParkingspotToEdit) { parkingspot in
            ParkingspotEdit(parkingspot: parkingspot)
                .environmentObject(wpvm)
        }
        .sheet(item: $selectedParkingspotToViewReservations, content: { parkingspot in
            ReservationList(parkingspot: parkingspot)
                .environmentObject(wpvm)
        })
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
        ParkingspotList()
            .environmentObject(WPViewModel())
//        GeometryReader{ proxy in
//            let bottomSpace = proxy.safeAreaInsets.bottom
//            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
//                .environmentObject(Network())
//                .ignoresSafeArea(.all, edges: .bottom)
//        }
    }
}
