//
//  SearchView.swift
//  WillParken
//
//  Created by Arbi Said on 12.02.23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @EnvironmentObject var wpvm: WPViewModel
    @StateObject var mapapi: Mapapi = Mapapi()
    
    @State private var filterEditSheetOpen = false
    @State private var useFilters = false
    @State private var selectedParkingspotToReserve: Parkingspot?
    
    @State private var priceperhour = 0
    @State private var tags: [String] = []
    @State private var weekdays: [Int] = []
    @State private var dayfrom = Date()
    @State private var dayuntil = Date()
    @State private var timefrom = Date()
    @State private var timeuntil = Date()
    
    @State private var country = "Austria"
    @State private var city = "Wels"
    @State private var zip = "4600"
    @State private var street = "Kamerlweg"
    @State private var houseno = "21a"
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                WPTitle(title: "Suchen", description: "Finde deinen Platz.")
                    .padding(.horizontal,20)
                
                //  Address
                VStack{
                    VStack{
                        HStack{
                            WPTagContainer (tag: "Land") { AnyView(
                                WPDropdownMenu(selectedItem: $country, selectionArray: ["Austria","Germany"])
                            )}
                            .frame(minWidth: 125, maxHeight: 70)
                            WPTagContainer (tag: "Stadt") { AnyView(
                                WPTextField(placeholder: "Stadt", text: $city)
                            )}
                            .frame(minWidth: 125)
                            WPTagContainer (tag: "PLZ") { AnyView(
                                WPTextField(placeholder: "PLZ", text: $zip)
                            )}
                        }
                        HStack{
                            WPTagContainer (tag: "Straße") { AnyView(
                                WPTextField(placeholder: "Straße", text: $street)
                            )}
                            .frame(minWidth: 250)
                            WPTagContainer (tag: "Haus Nr") { AnyView(
                                WPTextField(placeholder: "Haus Nr", text: $houseno)
                            )}
                        }
                        HStack{
                            WPButton(backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.85), foregroundColor: .white, label: "Suchen") {
                                wpvm.searchParkingspots(address: makeAddress()) { response in
                                    if let response = response {
                                        print(response)
                                        mapapi.setLocationsWithMAddressArray(arrayOfMAddress: wpvm.getSearchedParkingspotsMAddressArray())
                                    }
                                }
                            }
                            Button {
                                filterEditSheetOpen = true
                            } label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.85))
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.bottom)
                    
                    Map(coordinateRegion: $mapapi.region, annotationItems: mapapi.locations) { location in
                        MapMarker(coordinate: location.coordinate, tint: .blue)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.95)
                    .frame(alignment: .center)
                    .cornerRadius(5)
                    .shadow(radius: 4)
                }
                .padding(.top)
                .padding(.horizontal,15)
                
                Divider()
                    .padding([.top,.bottom])
                
                if let parkingspots = wpvm.searchedParkingspots{
                    VStack{
                        ForEach(filteredParkingspots(parkingspots: parkingspots)) { iParkingspot in
                            ParkingspotCard(parkingspot: iParkingspot)
                                .onTapGesture {
                                    guard wpvm.currentUser?.uc_cars.count ?? 0 > 0 else {
                                        errorMsg = "Es wurden noch keine Fahrzeuge hinzugefügt."
                                        isError = true
                                        return
                                    }
                                    guard iParkingspot.p_status != "deleted" else {
                                        errorMsg = "Dieser Parkplatz wurde bereits gelöscht."
                                        isError = true
                                        return
                                    }
                                    selectedParkingspotToReserve = iParkingspot
                                }
                        }
                    }
                    .padding(.horizontal,15)
                }
                
                Rectangle()
                    .foregroundColor(Color(.black).opacity(0))
                    .frame(height: 80)
            }
            .padding(.horizontal,15)
        }
        .sheet(isPresented: $filterEditSheetOpen) {
            SearchFilterEdit(useFilters: $useFilters, priceperhour: $priceperhour, tags: $tags, weekdays: $weekdays, dayfrom: $dayfrom, dayuntil: $dayuntil, timefrom: $timefrom, timeuntil: $timeuntil)
        }
        .sheet(item: $selectedParkingspotToReserve) { parkingspot in
            ReservationEdit(parkingspot: parkingspot)
                .environmentObject(wpvm)
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
    }
    
    private func makeAddress() -> Address{
        let address = Address(a_country: country, a_city: city, a_zip: zip, a_street: street, a_houseno: houseno, a_longitude: 0.0, a_latitude: 0.0)
        
        return address
    }
    
    private func filteredParkingspots(parkingspots: [Parkingspot]) -> [Parkingspot]{
        var newParkingspots: [Parkingspot] = []
        
        if useFilters {
            for ps in parkingspots{
                //  If (price is set and the price matches) or (price is not net) -> ok
                //  If (tags are set and the tags match) or (tags are not set) -> ok
                //  And so on.
                if ((priceperhour > 0 && ps.p_priceperhour <= priceperhour) || (priceperhour == 0)) &&
                    ((tags.count > 0 && ps.p_tags.contains(tags)) || (tags.count == 0)) &&
                    ((weekdays.count > 0 && ps.pt_availability.t_weekday.contains(weekdays)) || (weekdays.count == 0) || (ps.pt_availability.t_weekday.count == 0 || ps.pt_availability.t_weekday.count == 7)){
                    newParkingspots.append(ps)
                }
            }
        }else{
            newParkingspots = parkingspots
        }
        
        return newParkingspots
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(mapapi: Mapapi())
            .environmentObject(WPViewModel())
    }
}
