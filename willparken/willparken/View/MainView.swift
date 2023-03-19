//
//  MainView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var wpvm: WPViewModel
    @State var registerSwitch: Bool = false
    
    @State var splashScreenActive: Bool = true
    
    var body: some View {
        Group {
            if !splashScreenActive{
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
            } else {
                ZStack{
                    Rectangle()
                        .fill(Color(red: 30/255, green: 10/255, blue: 78/255))
                        .ignoresSafeArea()
                    Image("WillParkenLogo")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2)
                                .blur(radius: 2)
                        )
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+2.5){
                withAnimation {
                    self.splashScreenActive = false
                }
            }
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
