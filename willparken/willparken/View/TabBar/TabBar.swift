//
//  TabBar.swift
//  WillParken
//
//  Created by Arbi Said on 10.02.23.
//  Source: https://www.youtube.com/watch?v=1RGd-I7KNVA

import SwiftUI

struct TabBar: View {
    @Binding var currentTab: String
    var bottomSpace: CGFloat
    var body: some View {
        HStack (spacing: 0) {
            ForEach(["Search","Dashboard","Profile"], id: \.self) { tab in
                TabBarButton(icon: tab, currentTab: $currentTab)
            }
        }
        .padding(.top, 15)
        .padding(.bottom, bottomSpace)
    }
}
