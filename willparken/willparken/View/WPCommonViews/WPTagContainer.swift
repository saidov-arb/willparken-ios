//
//  WPTagContainer.swift
//  WillParken
//
//  Created by Arbi Said on 26.02.23.
//

import SwiftUI

struct WPTagContainer: View {
    var tag: String = "Tag"
    var container: () -> AnyView
    
    var body: some View {
        VStack(alignment:.leading){
            Text(tag)
                .font(.caption)
                .padding(.bottom,-4)
                .padding(.leading,2)
            container()
        }
    }
}

struct WPTagContainerTest: View {
    @State var text = "Text"
    var body: some View{
        WPTagContainer(tag: "Username") {
            AnyView(
                WPTextField(placeholder: "Ralf", text: $text)
            )
        }
    }
}

struct WPTagContainer_Previews: PreviewProvider {
    static var previews: some View {
        WPTagContainerTest()
    }
}
