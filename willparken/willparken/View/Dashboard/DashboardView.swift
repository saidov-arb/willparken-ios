//
//  DashboardView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var wpvm: WPViewModel
    
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: false){
                WPTitle(title: "WillParken", description: "Bleib stabil.")
                    .padding(.bottom, 25)
                
                DashboardCard(title: "Parkplätze (\(wpvm.currentParkingspots?.count ?? 0))", destination: {
                    AnyView(
                        ParkingspotList()
                            .environmentObject(wpvm)
                    )
                }, container: wpvm.currentParkingspots?.count ?? 0 > 0 ? {
                    if let parkingspots = wpvm.currentParkingspots {
                        return AnyView(
                            ForEach(parkingspots.prefix(3)) { iParkingspot in
                                HStack{
                                    Image(systemName: "parkingsign.circle.fill")
                                        .font(.title)
                                        .padding([.leading,.trailing],5)
                                    VStack (alignment: .leading){
                                        HStack{
                                            Image(systemName: "mappin.and.ellipse")
                                            Text("\(iParkingspot.pa_address.a_zip)")
                                            Divider().frame(height: 20).background(.blue)
                                            Text("\(iParkingspot.pa_address.a_street) \(iParkingspot.pa_address.a_houseno)")
                                            Divider().frame(height: 20).background(.blue)
                                            Text("\(iParkingspot.p_number)")
                                        }
                                    }
                                    .lineLimit(1)
                                    Spacer()
                                }
                            }
                        )
                    } else {
                        return AnyView(EmptyView())
                    }
                } : nil)
                
                DashboardCard(title: "Fahrzeuge (\(wpvm.currentUser?.uc_cars.count ?? 0))", destination: {
                    AnyView(
                        CarList()
                            .environmentObject(wpvm)
                    )
                }, container: wpvm.currentUser?.uc_cars.count ?? 0 > 0 ? {
                    if let cars = wpvm.currentUser?.uc_cars {
                        return AnyView(
                            ForEach(cars.prefix(3)){ iCar in
                                HStack{
                                    Image(systemName: "car.fill")
                                        .font(.title)
                                        .padding([.leading,.trailing],5)
                                    VStack (alignment: .leading){
                                        HStack{
                                            Text("\(iCar.c_brand) \(iCar.c_model)")
                                            Divider().frame(height: 20).background(.blue)
                                            Text("\(iCar.c_licenceplate)")
                                        }
                                        .textCase(.uppercase)
                                    }
                                }
                            }
                        )
                    }else{
                        return AnyView(EmptyView())
                    }
                } : nil)
                
                DashboardCard(title: "Reservierungen (\(wpvm.currentReservations?.count ?? 0))", destination: {
                    AnyView(
                        ReservationList()
                            .environmentObject(wpvm)
                    )
                }, container: wpvm.currentReservations != nil ? {
                    if let reservations = wpvm.currentReservations {
                        return AnyView(
                            ForEach(reservations.prefix(3)){ iReservation in
                                HStack{
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.title)
                                        .padding([.leading,.trailing],5)
                                    VStack (alignment: .leading){
                                        Text("\(iReservation.rt_timeframe.dayfromAsString) - \(iReservation.rt_timeframe.dayuntilAsString)")
                                        Text("\(iReservation.rt_timeframe.timefromAsString) - \(iReservation.rt_timeframe.timeuntilAsString)")
                                    }
                                    .textCase(.uppercase)
                                }
                            }
                        )
                    }else{
                        return AnyView(EmptyView())
                    }
                }: nil)
                
                Rectangle()
                    .foregroundColor(Color(.black).opacity(0))
                    .frame(height: 80)
            }
            .padding(.horizontal, 15)
        }
        .refreshable {
            wpvm.loadParkingspotsFromUser()
            wpvm.loadCarsFromUser()
            wpvm.loadReservationsFromUser()
        }
        .onAppear {
            wpvm.loadParkingspotsFromUser()
            wpvm.loadCarsFromUser()
            wpvm.loadReservationsFromUser()
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
//        DashboardView()
//            .environmentObject(Network())
        GeometryReader{ proxy in
            let bottomSpace = proxy.safeAreaInsets.bottom
            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                .environmentObject(WPViewModel())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
