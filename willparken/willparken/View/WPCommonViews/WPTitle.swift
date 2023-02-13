//
//  MainTitleView.swift
//  WillParken
//
//  Created by Arbi Said on 16.01.23.
//

import SwiftUI

struct WPTitle: View {
    let title: String
    let description: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(title)
                .font(.title)
                .foregroundColor(Color(.blue))
                .fontWeight(.regular)
            Text(description)
                .font(.subheadline)
                .foregroundColor(Color(.blue))
                .fontWeight(.light )
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

struct MainTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WPTitle(title: "WillParken", description: "Wo willst du denn parken?" )
    }
}
