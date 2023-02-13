//
//  TabBarSkeleton.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI

struct TabBarSkeleton: View {
    @EnvironmentObject var network: Network
    @State var currentTab: String = "Dashboard"
    var bottomSpace: CGFloat
    
    init(bottomSpace: CGFloat) {
        //  This hides the "Native Tabbar", which would take unneccessary space
        UITabBar.appearance().isHidden = true
        
        self.bottomSpace = bottomSpace
    }
    
    var body: some View {
        VStack {
            //  The View, where tag equals $currentTab will be active/shown
            TabView (selection: $currentTab) {
                SearchView()
                    .tag("Search")
                    .environmentObject(network)
                DashboardView()
                    .tag("Dashboard")
                    .environmentObject(network)
                ProfileView()
                    .tag("Profile")
                    .environmentObject(network)
            }
            .overlay(
                //  This is the actual TabBar
                TabBar(currentTab: $currentTab, bottomSpace: bottomSpace),
                alignment: .bottom
            )
        }
    }
}

struct TabBarSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ proxy in
            let bottomSpace = proxy.safeAreaInsets.bottom
            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                .environmentObject(Network())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
