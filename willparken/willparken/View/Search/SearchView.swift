//
//  SearchView.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        VStack {
            Text("This is the SearchView")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Network())
    }
}
