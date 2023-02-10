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
//            Text("Ich WillParken!")
//                .font(.largeTitle)
//                .frame(maxWidth: .infinity, alignment: .center)
            WPTitle(title: "WillParken", description: "Bleib stabil.")
            
            Spacer()
            
            Text("Register")
                .font(.title)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            WPTextField(placeholder: "Username", text: $username)
                .padding(.top,20)
            HStack (spacing: 10) {
                WPTextField(placeholder: "Firstname", text: $firstname)
                WPTextField(placeholder: "Lastname", text: $lastname)
            }
            .padding(.top,10)
            WPTextField(placeholder: "Email", text: $email)
                .padding(.top,10)
            WPTextField(placeholder: "Password", text: $password, isPassword: true)
                .padding(.top,10)
            WPTextField(placeholder: "Confirm Password", text: $passwordConfirm, isPassword: true)
                .padding(.top,10)
            
            HStack{
                WPButton(backgroundColor: .blue,foregroundColor: .white,label: "Register"){
                    guard !username.isEmpty, !firstname.isEmpty, !lastname.isEmpty, !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty else {
                        print("One or more fields are empty.")
                        return
                    }
                    guard password == passwordConfirm else {
                        print("Passwords do not match.")
                        return
                    }
                    network.registerUser(iUsername: username, iEmail: email, iFirstname: firstname, iLastname: lastname, iPassword: password)
                }
                
                WPButton(label: "LogIn"){
                    registerSwitch.toggle()
                }
            }
            .padding(.top,35)
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical)
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
