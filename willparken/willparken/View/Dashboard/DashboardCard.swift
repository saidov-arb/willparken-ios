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
    var container: (() -> AnyView)?
    
    var body: some View {
        VStack (alignment: .leading){
            
            Group {
                NavigationLink {
                    destination()
                        .navigationTitle(title)
                } label: {
                    VStack{
                        HStack{
                            Text(title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding([.bottom], container == nil ? 10 : 0)
                        if container != nil {
                            Divider()
                                .padding(.top,-4)
                        }
                    }
                }
                .font(.title2)
                .padding([.leading,.trailing,.top],10)
                
                if let container = container {
                    container()
                        .padding([.leading,.trailing,.bottom],10)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.03))
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.blue)
        )
        .padding(3)
    }
}

struct DashboardCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DashboardCard(title: "Title", destination: {
                AnyView(
                    Text("Destination")
                )
            }, container: {
                AnyView(
                    Text("Container")
                )
            })
        }
    }
}
