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
        VStack(alignment: .leading, spacing: 5){
            HStack(alignment: .center, spacing: 5){
                MainTitleView(title: "WillParken", description: "Bleib stabil.")
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            
            
            HStack(alignment: .center, spacing: 10){
                Spacer()
                    .frame(minWidth: 0,maxWidth: .infinity)
                
                Button{
                    
                } label: {
                    ServiceObjectView(
                        serviceTitle: "Parkplätze",
                        serviceImage: Image(systemName: "magnifyingglass")
                    )
                }
                
                Spacer()
                    .frame(minWidth: 0,maxWidth: .infinity)
                
                Button{
                    
                } label: {
                    ServiceObjectView(
                        serviceTitle: "Parkplätze",
                        serviceImage: Image(systemName: "magnifyingglass")
                    )
                }
                
                Spacer()
                    .frame(minWidth: 0,maxWidth: .infinity)
                
                Button{
                    
                } label: {
                    ServiceObjectView(
                        serviceTitle: "Parkplätze",
                        serviceImage: Image(systemName: "magnifyingglass")
                    )
                }
                
                Spacer()
                    .frame(minWidth: 0,maxWidth: .infinity)
            }
            
            ScrollView{
                Text("All Parkingspots")
                    .font(.title)
                    .bold()
                ForEach(network.parkingspots!){ parkingspot in
                    ParkingspotSlotView(spot: parkingspot)
                }
            }
            .onAppear(){
                network.getParkingspots()
            }
        }
        .padding(.horizontal, 20)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(Network())
    }
}
