//
//  WillParkenApp.swift
//  WillParken
//
//  Created by Arbi Said on 11.01.23.
//

import SwiftUI

@main
struct WillParkenApp: App {
    
    var network = WPapi()
    
    var body: some Scene {
        WindowGroup {
//            var user = network.users![0]
            //  EnvironmentObject is a great way to send an object
            //  to another View, while the developer doesn't have to
            //  take care of updating the Values over and over again.
            MainView()
                .environmentObject(network)
        }
    }
}
