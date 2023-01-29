//
//  RegisterView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var network: Network
    @Binding var registerSwitch: Bool
    @State private var username: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.title)
            
            WPTextField(placeholder: "Username", text: $username)
            HStack{
                WPTextField(placeholder: "Firstname", text: $firstname)
                WPTextField(placeholder: "Lastname", text: $lastname)
            }
            WPTextField(placeholder: "Email", text: $email)
            WPTextField(placeholder: "Password", text: $password, isPassword: true)
            WPTextField(placeholder: "Confirm Password", text: $passwordConfirm, isPassword: true)
            
            HStack{
                WPButton(action: {
                    guard !username.isEmpty, !firstname.isEmpty, !lastname.isEmpty, !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty else {
                        print("One or more fields are empty.")
                        return
                    }
                    guard password == passwordConfirm else {
                        print("Passwords do not match.")
                        return
                    }
                    network.registerUser(iUsername: username, iEmail: email, iFirstname: firstname, iLastname: lastname, iPassword: password)
                }, label: "Register")
                
                WPButton(action: {
                    registerSwitch.toggle()
                }, label: "LogIn")
            }
            
        }
        .padding()
        .frame(maxWidth: 350)
    }
}

struct RegisterViewTest: View {
    @State var registerSwitch: Bool = true
    var body: some View {
        RegisterView(registerSwitch: $registerSwitch)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterViewTest()
    }
}
