//
//  WPButton.swift
//  WillParken
//
//  Created by Arbi Said on 29.01.23.
//

import SwiftUI

struct WPButton: View {
    var action: () -> Void
    var label: String
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white

    var body: some View {
        Button(action: action, label: { Text(label).padding(10) })
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(20)
            .padding()
    }
}

struct WPButton_Previews: PreviewProvider {
    static var previews: some View {
        WPButton(action: {
            print("Button clicked.")
        }, label: "Button")
    }
}
