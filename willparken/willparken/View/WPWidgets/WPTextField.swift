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
    @State var isFocused: Bool = false
        
    var body: some View {
        if(!isPassword){
            TextField(placeholder, text: $text){ isEditing in
                    self.isFocused = isEditing
            }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(12)
                .fontWeight(.semibold)
                .background(text == "" ? Color.gray.opacity(0.05) : Color.purple.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    Group {
                        if isFocused {
                            RoundedRectangle(cornerRadius: 12).stroke(.blue)
                        }
                    }
                )
                .onTapGesture {
                    self.isFocused = true
                }
        } else {
            SecureField(placeholder, text: $text) {
                self.isFocused = false
            }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(12)
                .fontWeight(.semibold)
                .background(text == "" ? Color.gray.opacity(0.05) : Color.purple.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    Group {
                        if isFocused {
                            RoundedRectangle(cornerRadius: 12).stroke(.blue)
                        }
                    }
                )
                .onTapGesture {
                    self.isFocused = true
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
