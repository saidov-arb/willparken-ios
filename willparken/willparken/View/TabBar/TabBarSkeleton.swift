//
//  TabBarSkeleton.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI

struct TabBarSkeleton: View {
    @EnvironmentObject var wpvm: WPViewModel
    @State var currentTab: String = "Dashboard"
    var bottomSpace: CGFloat
    
    init(bottomSpace: CGFloat) {
        //  This hides the "Native Tabbar", which would take unneccessary space
        UITabBar.appearance().isHidden = true
        
        self.bottomSpace = bottomSpace
    }
    
    var body: some View {
        //  The View, where tag equals $currentTab will be active/shown
        TabView (selection: $currentTab) {
            SearchView()
                .tag("Search")
                .environmentObject(wpvm)
            DashboardView()
                .tag("Dashboard")
                .environmentObject(wpvm)
            ProfileView()
                .tag("Profile")
                .environmentObject(wpvm)
        }
        .overlay(
            //  This is the actual TabBar
            TabBar(currentTab: $currentTab, bottomSpace: bottomSpace),
            alignment: .bottom
        )
        .padding(.top,5)
    }
}

struct TabBarSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ proxy in
            let bottomSpace = proxy.safeAreaInsets.bottom
            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                .environmentObject(WPViewModel())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
