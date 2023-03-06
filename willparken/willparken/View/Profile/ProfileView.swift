//
//  ProfileView.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var network: WPapi
    
    var body: some View {
        VStack {
            Text("This is the ProfileView")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(WPapi())
    }
}
