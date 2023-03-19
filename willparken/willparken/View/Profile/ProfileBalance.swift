//
//  ProfileBalance.swift
//  WillParken
//
//  Created by Arbi Said on 13.03.23.
//

import SwiftUI

struct ProfileBalance: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var currentMoney:Int = 10
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center){
                Text("Guthaben aufladen")
                    .foregroundColor(.blue)
            }
            .padding()
            Divider()
            VStack{
                WPTagContainer(tag: "Betrag eingeben:") { AnyView(
                    WPStepper(steps: 5, value: $currentMoney, in: 5...100)
                        .controlSize(.large)
                )}
                .padding(.top,120)
                Spacer()
                WPButton(backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.85), foregroundColor: .white, label: "Einzahlen") {
                    wpvm.addUserMoney(money: currentMoney) { msg in
                        if let msg = msg {
                            print(msg)
                        }
                        dismiss()
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
            }
            .padding(.vertical)
        }
    }
}

struct ProfileBalance_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileBalance()
                .environmentObject(WPViewModel())
        }
    }
}
