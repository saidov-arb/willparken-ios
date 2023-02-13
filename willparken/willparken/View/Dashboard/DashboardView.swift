//
//  DashboardView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                WPTitle(title: "WillParken", description: "Bleib stabil.")
                    .padding(.bottom, 25)
                
                
                DashboardCard(title: "Your Parkingspots (\(network.testParkingspots!.count))", destination: {
                    AnyView(
                        Text("All Parkingspots of User will be displayed here.")
                    )
                }) {
                    AnyView(
                        ForEach(network.testParkingspots!.prefix(3)){ iParkingspot in
                            HStack{
                                Image(systemName: "parkingsign.circle.fill")
                                    .font(.largeTitle)
                                    .padding([.leading,.trailing],10)
                                VStack (alignment: .leading){
                                    Text("\(iParkingspot.pa_address.a_zip) \(iParkingspot.pa_address.a_city)")
                                        .font(.title3)
                                    Text("\(iParkingspot.pa_address.a_address1)")
                                        .font(.body)
                                }
                                Spacer()
                                Text("\(iParkingspot.p_number)")
                                    .font(.largeTitle)
                                Spacer()
                            }
                        }
                    )
                }
                
                DashboardCard(title: "Your Cars (\(network.testUser!.uc_cars.count))", destination: {
                    AnyView(
                        Text("All Cars of User will be displayed here.")
                    )
                }) {
                    AnyView(
                        ForEach(network.testUser!.uc_cars.prefix(3)){ iCar in
                            HStack{
                                Image(systemName: "car.fill")
                                    .font(.largeTitle)
                                    .padding([.leading,.trailing],10)
                                VStack (alignment: .leading){
                                    Text("\(iCar.c_brand) \(iCar.c_model)")
                                        .font(.title2)
                                        .textCase(.uppercase)
                                    Text("\(iCar.c_licenceplate)")
                                        .font(.title2)
                                        .textCase(.uppercase)
                                }
                            }
                        }
                    )
                }
                
                
                
            }
            .padding(.horizontal, 25)
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
                .environmentObject(Network())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
