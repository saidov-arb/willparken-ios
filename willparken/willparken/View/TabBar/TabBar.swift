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
        ZStack{
            Capsule()
                .frame(height: 50)
                .padding([.leading,.trailing])
                .foregroundColor(Color(red: 0.80, green: 0.85, blue: 0.95))
                .overlay(
                    Capsule().stroke(.blue)
                        .padding([.leading,.trailing])
                )

            HStack (spacing: 0) {
                ForEach(["Search","Dashboard","Profile"], id: \.self) { tab in
                    TabBarButton(icon: tab, currentTab: $currentTab)
                }
            }
        }
        .padding(.top, 15)
        .padding(.bottom, bottomSpace)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ proxy in
            let bottomSpace = proxy.safeAreaInsets.bottom
            TabBarSkeleton(bottomSpace: bottomSpace == 0 ? 12 : bottomSpace)
                .environmentObject(WPapi())
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
