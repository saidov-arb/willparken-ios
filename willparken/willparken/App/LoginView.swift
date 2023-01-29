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
            Text("Login")
                .font(.title)
            
            WPTextField(placeholder: "Username", text: $username)
            WPTextField(placeholder: "Password", text: $password, isPassword: true)
            
            HStack{
                WPButton(action: {
                    guard !username.isEmpty, !password.isEmpty else {
                        print("One or more fields are empty.")
                        return
                    }
                    network.loginUser(iUsername: username, iPassword: password)
                }, label: "LogIn")
                
                WPButton(action: {
                    registerSwitch.toggle()
                }, label: "Register")
            }
            
        }
        .padding()
        .frame(maxWidth: 350)
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
