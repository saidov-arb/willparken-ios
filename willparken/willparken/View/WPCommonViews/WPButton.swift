//
//  WPButton.swift
//  WillParken
//
//  Created by Arbi Said on 29.01.23.
//

import SwiftUI

struct WPButton: View {
    var backgroundColor: Color = .white
    var foregroundColor: Color = .blue
    var borderColor: Color? = nil
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text(label)
                .fontWeight(.semibold)
                .foregroundColor(foregroundColor)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                }
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor != nil ? borderColor! : foregroundColor))
        })
    }
}

struct WPButton_Previews: PreviewProvider {
    static var previews: some View {
        WPButton(label: "Button"){
            print("Button clicked.")
        }
    }
}
