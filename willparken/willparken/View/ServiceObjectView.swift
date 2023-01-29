//
//  ServiceObjectView.swift
//  WillParken
//
//  Created by Arbi Said on 16.01.23.
//

import SwiftUI

struct ServiceObjectView: View {
    let serviceTitle: String
    let serviceImage: Image
    var body: some View {
        VStack(alignment: .center, spacing: 18){
            ZStack{
                serviceImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(20)
                    .frame(minWidth: 80, maxWidth:80)
                
            }
            .background(Color("Font1").cornerRadius(15))
            .shadow(color: Color("Font1").opacity(0.4), radius: 5,x:0,y:10)
            .padding(5)
            
            Text(serviceTitle)
                .font(.caption)
                .foregroundColor(Color("Font1"))
                .lineLimit(2)
        }
        .frame(minWidth: 80,maxWidth: .infinity)
    }
}

struct ServiceObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceObjectView(serviceTitle: "Parkplätze", serviceImage: Image(systemName: "magnifyingglass"))
    }
}
