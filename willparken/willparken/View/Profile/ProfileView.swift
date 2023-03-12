//
//  ProfileView.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var wpvm: WPViewModel
    
    var body: some View {
        VStack {
            Button {
                wpvm.logoutUser()
                wpvm.currentUser = nil
                wpvm.currentParkingspots = nil
                wpvm.searchedParkingspots = nil
            } label: {
                Text("LogOut.")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(WPViewModel())
    }
}
