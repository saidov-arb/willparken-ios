//
//  MainView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var network: Network
    //loginRegisterSwitch (when false then login, when true then register)
    @State var registerSwitch: Bool = false
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            if network.actualUser == nil {
                if registerSwitch{
                    LoginView(registerSwitch: $registerSwitch)
                        .environmentObject(network)
                } else {
                    RegisterView(registerSwitch: $registerSwitch)
                        .environmentObject(network)
                }
                
            } else {
                DashboardView()
                    .environmentObject(network)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Network())
    }
}
