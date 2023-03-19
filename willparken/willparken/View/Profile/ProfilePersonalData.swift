//
//  ProfilePersonalData.swift
//  WillParken
//
//  Created by Arbi Said on 13.03.23.
//

import SwiftUI

struct ProfilePersonalData: View {
    @EnvironmentObject var wpvm: WPViewModel
    
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        VStack{
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
            WPButton(backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.85), foregroundColor: .white, label: "Speichern") {
                updateUser()
            }
            .padding(.top)
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.5 : 1)
        .padding(.horizontal)
        .onAppear{
            if let user = wpvm.currentUser {
                firstname = user.u_firstname
                lastname = user.u_lastname
                email = user.u_email
            }
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
        .overlay(
            ZStack{
                if isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        )
    }
    
    private func updateUser(){
        guard firstname != "" && lastname != "" && email != "" else {
            errorMsg = "Alle Felder müssen ausgefüllt sein."
            isError = true
            return
        }
        guard isValidEmail() else {
            errorMsg = "Email ist ungültig."
            isError = true
            return
        }
        guard isNew() else {
            errorMsg = "Nichts verändert."
            isError = true
            return
        }
        isLoading = true
        wpvm.updateUser(firstname: firstname, lastname: lastname, email: email) { msg in
            if let msg = msg {
                print(msg)
            }
            isLoading = false
        } failure: { err in
            if let err = err {
                errorMsg = err
                isError = true
            }
            isLoading = false
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isNew() -> Bool {
        if let user = wpvm.currentUser {
            return firstname != user.u_firstname || lastname != user.u_lastname || email != user.u_email
        }
        return false
    }
}

struct ProfilePersonalData_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePersonalData()
            .environmentObject(WPViewModel())
    }
}
