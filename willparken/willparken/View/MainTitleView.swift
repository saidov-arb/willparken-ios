//
//  MainTitleView.swift
//  WillParken
//
//  Created by Arbi Said on 16.01.23.
//

import SwiftUI

struct MainTitleView: View {
    let title: String
    let description: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(title)
                .font(.title)
                .foregroundColor(Color("Font1"))
                .fontWeight(.regular)
            Text(description)
                .font(.caption)
                .foregroundColor(Color("Font1"))
                .fontWeight(.light )
        }
    }
}

struct MainTitleView_Previews: PreviewProvider {
    static var previews: some View {
        MainTitleView(title: "WillParken", description: "Wo willst du denn parken?" )
    }
}
