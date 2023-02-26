//
//  DashboardView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var network: WPapi
    
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: false){
                WPTitle(title: "WillParken", description: "Bleib stabil.")
                    .padding(.bottom, 25)
                
                DashboardCard(title: "Your Parkingspots (\(network.testParkingspots!.count))", destination: {
                    AnyView(
                        ParkingspotsList()
                            .environmentObject(network)
                    )
                }) {
                    AnyView(
                        ForEach(network.testParkingspots!.prefix(3)){ iParkingspot in
                            HStack{
                                Image(systemName: "parkingsign.circle.fill")
                                    .font(.title)
                                    .padding([.leading,.trailing],5)
                                VStack (alignment: .leading){
                                    HStack{
                                        Image(systemName: "mappin.and.ellipse")
                                        Text("\(iParkingspot.pa_address.a_zip)")
                                        Divider().frame(height: 20).background(.blue)
                                        Text("\(iParkingspot.pa_address.a_street)")
                                        Divider().frame(height: 20).background(.blue)
                                        Text("\(iParkingspot.p_number)")
                                    }
                                }
                                .lineLimit(1)
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
                }
                
                Rectangle()
                    .foregroundColor(Color(.black).opacity(0))
                    .frame(height: 50)
            }
            .padding(.horizontal, 15)
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
                .environmentObject(WPapi())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
