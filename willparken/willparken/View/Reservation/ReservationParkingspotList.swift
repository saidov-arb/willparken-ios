//
//  ReservationParkingspotList.swift
//  WillParken
//
//  Created by Arbi Said on 07.03.23.
//

import SwiftUI

struct ReservationParkingspotList: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Environment(\.dismiss) var dismiss
    @State var parkingspot: Parkingspot
    @State private var selectedReservation: Reservation?
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .padding()
        Divider()
        List {
            if wpvm.currentParkingspots != nil {
                if let reservations = wpvm.currentParkingspots![wpvm.currentParkingspots!.firstIndex(where: { $0._id == parkingspot._id }) ?? 0].pr_reservations{
                    ForEach(reservations) { iReservation in
                        ReservationCard(reservation: iReservation)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    selectedReservation = iReservation
                                    wpvm.cancelReservation(parkingspotid: parkingspot._id, reservationid: iReservation._id) { msg in
                                        if let msg = msg {
                                            print(msg)
                                        }
                                    } failure: { err in
                                        if let err = err {
                                            if err.starts(with: "Reservation is") {
                                                errorMsg = "Die Reservierung wurde bereits storniert."
                                                isError = true
                                            } else if err.starts(with: "Cancellation time") {
                                                errorMsg = "Reservierung kann nicht mehr storniert werden."
                                                isError = true
                                            } else {
                                                print(err)
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "x.circle")
                                }
                                .tint(.red)
                            }
                    }
                    .listRowSeparator(Visibility.hidden)
                }
            }
            
            Rectangle()
                .foregroundColor(Color(.black).opacity(0))
                .frame(height: 80)
                .listRowSeparator(Visibility.hidden)
        }
        .refreshable {
            wpvm.loadParkingspotsFromUser()
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .alert(isPresented: $isError) {
            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
    }
}

struct ReservationListParkingspotTest: View {
    var parkingspot: Parkingspot = Parkingspot.makeSampleParkingspot()!
    var body: some View{
        ReservationParkingspotList(parkingspot: parkingspot)
            .environmentObject(WPViewModel())
    }
}

struct ReservationListParkingspot_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListParkingspotTest()
    }
}
