//
//  MainView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var wpvm: WPViewModel
    //loginRegisterSwitch (when false then login, when true then register)
    @State var registerSwitch: Bool = false
    var body: some View {
        Group {
            if wpvm.currentUser == nil {
                if registerSwitch{
                    RegisterView(registerSwitch: $registerSwitch)
                        .environmentObject(wpvm)
                } else {
                    LoginView(registerSwitch: $registerSwitch)
                        .environmentObject(wpvm)
                }
            } else {
                //  This GeometryReader is helpful to measure the safeAreas
                //  In this case the bottom safeArea is needed, so that the tabbar has the correct padding
                GeometryReader{ tempMeasurement in
                    let bottomSpace = tempMeasurement.safeAreaInsets.bottom
                    TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                        .environmentObject(wpvm)
                        .ignoresSafeArea(.all, edges: .bottom)
                }
            }
        }
        .onAppear{
            wpvm.getUser() { msg in
                if let msg = msg {
                    print(msg)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(WPViewModel())
    }
}
