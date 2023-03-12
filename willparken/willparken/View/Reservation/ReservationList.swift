//
//  ReservationList.swift
//  WillParken
//
//  Created by Arbi Said on 07.03.23.
//

import SwiftUI

struct ReservationList: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Environment(\.dismiss) var dismiss
    @State var parkingspot: Parkingspot
    @State private var selectedReservation: Reservation?
    
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
                                    }
                                } label: {
                                    Label("Cancel", systemImage: "x.circle")
                                }
                                .tint(.red)
                            }
                    }
                    .listRowSeparator(Visibility.hidden)
                }
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
    }
}

struct ReservationListTest: View {
    var parkingspot: Parkingspot = Parkingspot.makeSampleParkingspot()!
    var body: some View{
        ReservationList(parkingspot: parkingspot)
            .environmentObject(WPViewModel())
    }
}

struct ReservationList_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListTest()
    }
}
