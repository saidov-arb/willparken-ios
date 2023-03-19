//
//  WPStatusToggle.swift
//  WillParken
//
//  Created by Arbi Said on 06.03.23.
//

import SwiftUI

struct WPStatusToggle: View {
    @Binding var isActive: Bool
    var text: String
    var height: CGFloat? = 25
    var maxWidth: CGFloat? = .infinity
    var body: some View{
        Button {
            isActive.toggle()
        } label: {
            Text(text)
                .frame(maxWidth: maxWidth)
                .frame(height: height)
                .background(isActive ? Color(red: 0.85, green: 0.85, blue: 1) : Color.gray.opacity(0.05))
                .foregroundColor(.black)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.75, green: 0.75, blue: 1)).blur(radius: 2))
        }
    }
}

struct WPStatusToggleTest: View {
    @State var isActive: Bool = false
    var body: some View{
        WPStatusToggle(isActive: $isActive, text: "Ralf")
    }
}

struct WPStatusToggle_Previews: PreviewProvider {
    static var previews: some View {
        WPStatusToggleTest()
    }
}
