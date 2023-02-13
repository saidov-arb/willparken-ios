//
//  DashboardCard.swift
//  WillParken
//
//  Created by Arbi Said on 13.02.23.
//

import SwiftUI

struct DashboardCard: View {
    var title: String = "Title"
    var destination: () -> AnyView
    var container: () -> AnyView
    
    var body: some View {
        VStack (alignment: .leading){
            
            Group {
                NavigationLink {
                    destination()
                } label: {
                    VStack{
                        HStack{
                            Text(title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        Divider()
                    }
                }
                .font(.title2)
                
                container()
            }
            .padding(10)
            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.blue)
        )
        .padding(5)
    }
}

struct DashboardCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DashboardCard(title: "Title", destination: {
                AnyView(
                    Text("Destination")
                )
            }) {
                AnyView(
                    ForEach(0 ..< 3){ value in
                        Text("\(value)")
                    }
                )
            }
        }
    }
}
