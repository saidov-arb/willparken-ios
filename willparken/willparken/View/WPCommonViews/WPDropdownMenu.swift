//
//  WPDropdownMenu.swift
//  WillParken
//
//  Created by Arbi Said on 11.03.23.
//

import SwiftUI

struct WPDropdownMenu: View {
    @Binding var selectedItem: String
    var selectionArray: [String]
    
    var body: some View {
        Menu {
            ForEach(selectionArray, id: \.self){ item in
                Button(item) {
                    selectedItem = item
                }
            }
            
        } label: {
            HStack{
                Text(selectedItem)
                   .foregroundColor(.black)
               Spacer()
               Image(systemName: "chevron.down")
                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.7))
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(12)
            .background(Color.purple.opacity(0.05))
            .cornerRadius(12)
            .fontWeight(.semibold)
        }
    }
}

struct WPDropdownMenuTest: View {
    @State var selectedItem: String = "Germany"
    var selectionArray: [String] = ["Austria", "Germany", "UK", "USA"]
    
    var body: some View {
        WPDropdownMenu(selectedItem: $selectedItem, selectionArray: selectionArray)
    }
}

struct WPDropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        WPDropdownMenuTest()
    }
}
