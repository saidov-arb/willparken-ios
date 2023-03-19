//
//  ProfileView.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var wpvm: WPViewModel
    
    @State private var profileBalanceOpen: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                HStack{
                    WPTitle(title: "Profil", description: "Guthaben aufladen und los geht's!")
                        .padding(.bottom, 25)
                    Spacer()
                    VStack {
                        Button {
                            wpvm.logoutUser()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .resizable()
                                .frame(width: 30,height: 30)
                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.5))
                        }
                        .padding()
                        Spacer()
                    }
                }
                
                DashboardCard(title: "Persönliche Daten"){AnyView(
                    ProfilePersonalData()
                        .environmentObject(wpvm)
                )}
                
//                DashboardCard(title: "Sicherheit"){AnyView(
//                    ProfileSecurity()
//                        .environmentObject(wpvm)
//                )}
                
                if let user = wpvm.currentUser {
                    VStack{
                        HStack{
                            Text("\(user.u_balance) €")
                                .font(Font.title.bold())
                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.5))
                            Spacer()
                            Button {
                                profileBalanceOpen = true
                            } label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 40,height: 40)
                            }
                        }
                        .padding()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(.blue)
                    )
                    .padding(.horizontal,3)
                }

                
                Rectangle()
                    .foregroundColor(Color(.black).opacity(0))
                    .frame(height: 50)
            }
            .padding(.horizontal, 15)
        }
        .refreshable {
            wpvm.getUser { msg in
                if let msg = msg {
                    print(msg)
                }
            }
        }
        .onAppear {
//            wpvm.loadParkingspotsFromUser()
//            wpvm.loadCarsFromUser()
//            wpvm.loadReservationsFromUser()
        }
        .sheet(isPresented: $profileBalanceOpen) {
            ProfileBalance()
                .environmentObject(wpvm)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(WPViewModel())
    }
}
