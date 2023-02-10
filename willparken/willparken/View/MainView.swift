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

//            if network.actualUser == nil {
//                if registerSwitch{
//                    RegisterView(registerSwitch: $registerSwitch)
//                        .environmentObject(network)
//                } else {
//                    LoginView(registerSwitch: $registerSwitch)
//                        .environmentObject(network)
//                }
//
//            } else {
//                DashboardView()
//                    .environmentObject(network)
//            }
            GeometryReader{ proxy in
                let bottomSpace = proxy.safeAreaInsets.bottom
                DashboardView(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                    .environmentObject(network)
                    .ignoresSafeArea(.all, edges: .bottom)
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
