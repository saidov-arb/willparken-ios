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
                
                DashboardCard(title: "Your Parkingspots (\(wpvm.currentParkingspots?.count ?? 0))", destination: {
                    AnyView(
                        ParkingspotList()
                            .environmentObject(wpvm)
                    )
                }) {
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
                }
                
                DashboardCard(title: "Your Cars (\(wpvm.currentUser?.uc_cars.count ?? 0))", destination: {
                    AnyView(
                        CarList()
                            .environmentObject(wpvm)
                    )
                }) {
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
                }
                
                DashboardCard(title: "Your Reservations (\(wpvm.currentUser?.ur_reservations.count ?? 0))", destination: {
                    AnyView(
//                        ReservationList()
//                            .environmentObject(wpvm)
                        EmptyView()
                    )
                }) {
                    AnyView(EmptyView())
                }
                
                Rectangle()
                    .foregroundColor(Color(.black).opacity(0))
                    .frame(height: 50)
            }
            .padding(.horizontal, 15)
        }
        .refreshable {
            wpvm.loadParkingspotsFromUser()
            wpvm.loadCarsFromUser()
        }
        .onAppear {
            wpvm.loadParkingspotsFromUser()
            wpvm.loadCarsFromUser()
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
