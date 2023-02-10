//
//  TabBarButton.swift
//  WillParken
//
//  Created by Arbi Said on 10.02.23.
//

import SwiftUI

struct TabBarButton: View {
    var icon: String
    @Binding var currentTab: String
    
    var body: some View {
        Button {
            withAnimation{currentTab = icon}
        } label: {
            Image(systemName: icon == "Search" ? "magnifyingglass" : icon == "Dashboard" ? "house" : "person")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30,height: 30)
                .frame(maxWidth: .infinity)
                .foregroundColor(currentTab == icon ? Color.blue : Color.gray.opacity(0.5))
        }

    }
}
