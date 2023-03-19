//
//  RegisterView.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Binding var registerSwitch: Bool
    
    @State private var username: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        VStack {
            WPTitle(title: "WillParken", description: "Bleib stabil.")
            
            Spacer()
            
            ScrollView{
                Group{
                    HStack{
                        Text("Registrieren")
                            .font(.title)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        if(isLoading){
                            ProgressView()
                        }
                    }
                    
                    
                    WPTagContainer(tag: "Benutzername") {AnyView(
                        WPTextField(placeholder: "Benutzername", text: $username)
                    )}
                    .padding(.top,10)
                    HStack (spacing: 10) {
                        WPTagContainer(tag: "Vorname") {AnyView(
                            WPTextField(placeholder: "Vorname", text: $firstname)
                        )}
                        WPTagContainer(tag: "Nachname") {AnyView(
                            WPTextField(placeholder: "Nachname", text: $lastname)
                        )}
                    }
                    .padding(.top,10)
                    WPTagContainer(tag: "Email") {AnyView(
                        WPTextField(placeholder: "Email", text: $email)
                    )}
                    .padding(.top,10)
                    WPTagContainer(tag: "Passwort") {AnyView(
                        WPTextField(placeholder: "Passwort", text: $password, isPassword: true)
                    )}
                    .padding(.top,10)
                    WPTagContainer(tag: "Passwort bestätigen") {AnyView(
                        WPTextField(placeholder: "Passwort bestätigen", text: $passwordConfirm, isPassword: true)
                    )}
                    .padding(.top,10)
                    
                    HStack{
                        WPButton(backgroundColor: .blue,foregroundColor: .white,label: "Registrieren"){
                            guard !username.isEmpty, !firstname.isEmpty, !lastname.isEmpty, !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty else {
                                errorMsg = "Bitte alle Felder ausfüllen."
                                isError = true
                                return
                            }
                            guard password == passwordConfirm else {
                                errorMsg = "Passwörter stimmen nicht überein."
                                isError = true
                                return
                            }
                            wpvm.registerUser(iUsername: username, iEmail: email, iFirstname: firstname, iLastname: lastname, iPassword: password) { msg in
                                if let msg = msg {
                                    print(msg)
                                }
                            } failure: { err in
                                if let err = err {
                                    errorMsg = err
                                    isError = true
                                }
                            }
                        }
                        .alert(isPresented: $isError) {
                            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
                        }
                        
                        WPButton(label: "Einloggen"){
                            registerSwitch.toggle()
                        }
                    } // HStack
                    .padding(.top,20)
                }
                .padding(.horizontal,2)
                
                
                Spacer()
                
            } // ScrollView
            .scrollIndicators(.hidden)
            .frame(height: UIScreen.main.bounds.height * 0.7)
            
            
            Spacer()
            
        } // VStack
        .disabled(isLoading)
        .opacity(isLoading ? 0.5 : 1)
        .padding(.horizontal, 25)
        .padding(.vertical)
    }
}

struct RegisterViewTest: View {
    @State var registerSwitch: Bool = true
    var body: some View {
        RegisterView(registerSwitch: $registerSwitch)
            .environmentObject(WPViewModel())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterViewTest()
    }
}
