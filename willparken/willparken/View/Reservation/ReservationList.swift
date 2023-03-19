//
//  ReservationList.swift
//  WillParken
//
//  Created by Arbi Said on 12.03.23.
//

import SwiftUI

struct ReservationList: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedReservation: Reservation?
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        List {
            if let reservations = wpvm.currentReservations {
                ForEach(reservations) { iReservation in
                    if let car = wpvm.currentUser?.uc_cars.first(where: {$0._id == iReservation.rc_car}) {
                        ReservationCard(reservation: iReservation, car: car)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    selectedReservation = iReservation
                                    //  Select the parkignspotid of selectedReservation
                                    if let parkingspotid = wpvm.currentUser?.ur_reservations.first(where: {$0.reservationid == selectedReservation?._id})?.parkingspotid {
                                        wpvm.cancelReservation(parkingspotid: parkingspotid, reservationid: iReservation._id) { msg in
                                            if let msg = msg {
                                                print(msg)
                                            }
                                        } failure: { err in
                                            if let err = err {
                                                if err.starts(with: "400") {
                                                    errorMsg = "Die Reservierung wurde bereits storniert."
                                                    isError = true
                                                } else if err.starts(with: "401") {
                                                    errorMsg = "Reservierung kann nicht mehr storniert werden."
                                                    isError = true
                                                } else {
                                                    print(err)
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "x.circle")
                                }
                                .tint(.red)
                            }
                    }
                }
                .listRowSeparator(Visibility.hidden)
            }
            
            Rectangle()
                .foregroundColor(Color(.black).opacity(0))
                .frame(height: 80)
                .listRowSeparator(Visibility.hidden)
        }
        .refreshable {
            wpvm.loadReservationsFromUser()
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .alert(isPresented: $isError) {
            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
    }
}

struct ReservationList_Previews: PreviewProvider {
    static var previews: some View {
        ReservationList()
            .environmentObject(WPViewModel())
    }
}
