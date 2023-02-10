//
//  DashboardView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var network: Network
    @State var currentTab: String = "Dashboard"
    var bottomSpace: CGFloat
    
    init(bottomSpace: CGFloat) {
        //  This can be removed maybe...
        //  This hides the "Native Tabbar"...
        UITabBar.appearance().isHidden = true
        
        self.bottomSpace = bottomSpace
    }
    
    var body: some View {
        VStack {
            WPTitle(title: "WillParken", description: "Bleib stabil.")
            
            //  The View, where tag equals $currentTab will be active/shown
            TabView (selection: $currentTab) {
                Text("Search")
                    .tag("Search")
                Text("Dashboard")
                    .tag("Dashboard")
                Text("Profile")
                    .tag("Profile")
            }
            .overlay(
                //  This is the actual TabBar
                TabBar(currentTab: $currentTab, bottomSpace: bottomSpace),
                alignment: .bottom
            )
            
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ proxy in
            let bottomSpace = proxy.safeAreaInsets.bottom
            DashboardView(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                .environmentObject(Network())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
