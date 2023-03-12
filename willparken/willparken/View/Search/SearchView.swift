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
    
    var body: some View {
        ScrollView {
            
            //  Address
            VStack{
                VStack{
                    HStack{
                        WPTagContainer (tag: "Country") { AnyView(
                            WPDropdownMenu(selectedItem: $country, selectionArray: ["Austria","Germany"])
                        )}
                        .frame(minWidth: 125, maxHeight: 70)
                        WPTagContainer (tag: "City") { AnyView(
                            WPTextField(placeholder: "City", text: $city)
                        )}
                        .frame(minWidth: 125)
                        WPTagContainer (tag: "ZIP") { AnyView(
                            WPTextField(placeholder: "ZIP", text: $zip)
                        )}
                    }
                    HStack{
                        WPTagContainer (tag: "Street") { AnyView(
                            WPTextField(placeholder: "Street", text: $street)
                        )}
                        .frame(minWidth: 250)
                        WPTagContainer (tag: "Houseno") { AnyView(
                            WPTextField(placeholder: "Houseno", text: $houseno)
                        )}
                    }
                    HStack{
                        WPButton(backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.85), foregroundColor: .white, label: "Search") {
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
                        .padding(.horizontal)
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
            .padding(.horizontal)
            
            Divider()
                .padding([.top,.bottom])
            
            if let parkingspots = wpvm.searchedParkingspots{
                VStack{
                    if useFilters {
                        ForEach(filteredParkingspots(parkingspots: parkingspots)) { iParkingspot in
                            ParkingspotCard(parkingspot: iParkingspot)
                        }
                    }else{
                        ForEach(parkingspots) { iParkingspot in
                            ParkingspotCard(parkingspot: iParkingspot)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Rectangle()
                .foregroundColor(Color(.black).opacity(0))
                .frame(height: 50)
        }
        .padding(.horizontal,15)
        .sheet(isPresented: $filterEditSheetOpen) {
            SearchFilterEdit(useFilters: $useFilters, priceperhour: $priceperhour, tags: $tags, weekdays: $weekdays, dayfrom: $dayfrom, dayuntil: $dayuntil, timefrom: $timefrom, timeuntil: $timeuntil)
        }
    }
    
    private func makeAddress() -> Address{
        let address = Address(a_country: country, a_city: city, a_zip: zip, a_street: street, a_houseno: houseno, a_longitude: 0.0, a_latitude: 0.0)
        
        return address
    }
    
    private func filteredParkingspots(parkingspots: [Parkingspot]) -> [Parkingspot]{
        var newParkingspots: [Parkingspot] = []
        
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
        
        return newParkingspots
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(mapapi: Mapapi())
            .environmentObject(WPViewModel())
    }
}
