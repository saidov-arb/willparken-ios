//
//  WPTextField.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct WPTextField: View {
    var placeholder: String
    @Binding var text: String
    var isPassword: Bool = false
        
    var body: some View {
        HStack {
            VStack{
                if(!isPassword){
                    TextField(placeholder, text: $text)
                        .padding([.leading, .trailing], 12)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField(placeholder, text: $text)
                        .padding([.leading, .trailing], 12)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                Rectangle()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(Color.gray)
                    
            }
        }
    }
}

//Can be removed
private struct WPTextFieldTest: View{
    @State private var text: String = "Dings"
    var body: some View{
        VStack{
            WPTextField(placeholder: "Username", text: $text)
            WPTextField(placeholder: "Password", text: $text, isPassword: true)
        }
        .padding()
    }
}

struct WPTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        WPTextFieldTest()
    }
}
