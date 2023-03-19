//
//  LoginView.swift
//  WillParken
//
//  Created by Arbi Said on 29.01.23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Binding var registerSwitch: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    
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
                        Text("Anmelden")
                            .font(.title)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        if(isLoading){
                            ProgressView()
                        }
                    }
                    .padding(.trailing)
                    
                    WPTagContainer (tag: "Benutzername"){AnyView(
                        WPTextField(placeholder: "Benutzername", text: $username)
                    )}
                    .padding(.top, 10)
                    WPTagContainer (tag: "Passwort"){AnyView(
                        WPTextField(placeholder: "Passwort", text: $password, isPassword: true)
                    )}
                    .padding(.top, 10)
                    
                    HStack{
                        WPButton(backgroundColor: .blue, foregroundColor: .white, label: "Anmelden") {
                            guard username != "" && password != "" else {
                                errorMsg = "Bitte alle Felder ausfüllen."
                                isError = true
                                return
                            }
                            
                            isLoading = true
                            wpvm.loginUser(iUsername: username, iPassword: password) { msg in
                                isLoading = false
                                if let msg = msg {
                                    print(msg)
                                }
                            } failure: { err in
                                isLoading = false
                                if let err = err {
                                    errorMsg = "Falsches Passwort oder falscher Benutzername."
                                    isError = true
                                    print(err)
                                }
                            }
                        }
                        .alert(isPresented: $isError) {
                            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
                        }
                        
                        WPButton(backgroundColor: .white, foregroundColor: .blue, label: "Registrieren") {
                            registerSwitch.toggle()
                        }
                    } // HStack
                    .padding(.top,20)
                }
                .padding(.horizontal,2)
                
                Spacer()
                
            } // ScrollView
            .scrollIndicators(.hidden)
            .frame(height: UIScreen.main.bounds.height * 0.5)
            
            Spacer()
            
        } // VStack
        .disabled(isLoading)
        .opacity(isLoading ? 0.5 : 1)
        .padding(.horizontal, 25)
        .padding(.vertical)
    }
}


struct LoginViewTest: View {
    @State var registerSwitch: Bool = false
    var body: some View {
        LoginView(registerSwitch: $registerSwitch)
            .environmentObject(WPViewModel())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewTest()
    }
}
