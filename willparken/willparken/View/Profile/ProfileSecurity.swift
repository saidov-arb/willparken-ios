//
//  ProfileSecurity.swift
//  WillParken
//
//  Created by Arbi Said on 13.03.23.
//

import SwiftUI

struct ProfileSecurity: View {
    @EnvironmentObject var wpvm: WPViewModel
    
    var body: some View {
        Text("Passwort ändern, Account löschen.")
    }
}

struct ProfileSecurity_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSecurity()
            .environmentObject(WPViewModel())
    }
}
