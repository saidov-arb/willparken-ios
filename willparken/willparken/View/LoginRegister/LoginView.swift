//
//  LoginView.swift
//  WillParken
//
//  Created by Arbi Said on 29.01.23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var network: Network
    @Binding var registerSwitch: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            
//            Text("Ich WillParken!")
//                .font(.largeTitle)
//                .frame(maxWidth: .infinity, alignment: .center)
            WPTitle(title: "WillParken", description: "Bleib stabil.")
            
            Spacer()
            
            Text("Login")
                .font(.title)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            WPTextField(placeholder: "Username", text: $username)
                .padding(.top, 20)
            WPTextField(placeholder: "Password", text: $password, isPassword: true)
                .padding(.top, 10)
            
            HStack{
                WPButton(backgroundColor: .blue, foregroundColor: .white, label: "LogIn") {
                    guard !username.isEmpty, !password.isEmpty else {
                        print("One or more fields are empty.")
                        return
                    }
                    network.loginUser(iUsername: username, iPassword: password)
                }
                
                WPButton(backgroundColor: .white, foregroundColor: .blue, label: "Register") {
                    registerSwitch.toggle()
                }
            }
            .padding(.top, 35)
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical)
    }
}

struct LoginViewTest: View {
    @State var registerSwitch: Bool = false
    var body: some View {
        LoginView(registerSwitch: $registerSwitch)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewTest()
    }
}
