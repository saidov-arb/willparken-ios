//
//  ParkingspotDataTemplate.swift
//  WillParken
//
//  Created by Arbi Said on 23.02.23.
//

import SwiftUI
import MapKit

struct ParkingspotEdit: View {
    @EnvironmentObject var wpvm: WPViewModel
    @StateObject private var mapAPI = Mapapi()
    @Environment(\.dismiss) var dismiss
    var parkingspot: Parkingspot?
    
    @State private var empty = ""
    @State private var no = ""
    @State private var priceperhour = ""
    @State private var tags = [""]
    @State private var weekdays = [false,false,false,false,false,false,false]
    @State private var dayfrom = Date()
    @State private var dayuntil = Date()
    @State private var timefrom = Date()
    @State private var timeuntil = Date()
    @State private var country = ""
    @State private var city = ""
    @State private var zip = ""
    @State private var street = ""
    @State private var houseno = ""
    
    init(parkingspot: Parkingspot? = nil){
        if let iParkingspot = parkingspot {
            self.parkingspot = iParkingspot
            setStateValues(parkingspot: iParkingspot)
        }else{self.parkingspot = nil}
    }
    
    private func setStateValues(parkingspot: Parkingspot){
        no = String(parkingspot.p_number)
        priceperhour = String(parkingspot.p_priceperhour)
        tags = parkingspot.p_tags
        for dayIndex in parkingspot.pt_availability.t_weekday {
            weekdays[dayIndex-1].toggle()
        }
        dayfrom = parkingspot.pt_availability.dayfromAsDate
        dayuntil = parkingspot.pt_availability.dayuntilAsDate
        timefrom = parkingspot.pt_availability.timefromAsDate
        timeuntil = parkingspot.pt_availability.timeuntilAsDate
        country = parkingspot.pa_address.a_country
        city = parkingspot.pa_address.a_city
        zip = parkingspot.pa_address.a_zip
        street = parkingspot.pa_address.a_street
        houseno = parkingspot.pa_address.a_houseno
    }
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center){
                Button {
                    save()
                } label: {
                    Text("Save")
                }
                Spacer()
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding()
            Divider()
            ScrollView{
                VStack{
                    //  Number, Price and Tags
                    VStack{
                        HStack{
                            WPTagContainer(tag: "No") { AnyView(
                                WPTextField(placeholder: "No", text: $no)
                            )}
                            WPTagContainer(tag: "Price / hour") { AnyView(
                                WPTextField(placeholder: "Price", text: $priceperhour)
                            )}
                            Spacer()
                            WPTagContainer(tag: "Tags") { AnyView(
                                WPTextField(placeholder: "Tags", text: tags.count > 0 ? $tags[0] : $empty)
                            )}
                            .frame(minWidth: 200)
                        }
                    }
                    .padding([.bottom,.top])

                    //  Availability
                    VStack(alignment:.leading){
                        WPTagContainer(tag: "Weekday") { AnyView(
                            HStack{
                                ForEach(0..<7) { index in
                                    WeekdayButtonView(dayIndex: index, isActive: $weekdays[index])
                                }
                            }
                        )}
                        HStack{
                            WPTagContainer(tag: "Date from") { AnyView(
                                DatePicker("",selection: $dayfrom, displayedComponents: .date)
                                    .labelsHidden()
                            )}
                            WPTagContainer(tag: "Date until") { AnyView(
                                DatePicker("", selection: $dayuntil, displayedComponents: .date)
                                    .labelsHidden()
                            )}
                        }
                        HStack{
                            WPTagContainer(tag: "Time from") { AnyView(
                                DatePicker("",selection: $timefrom, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            )}
                            WPTagContainer(tag: "Time until") { AnyView(
                                DatePicker("",selection: $timeuntil, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            )}
                        }
                    }
                    .padding([.bottom,.top])

                    //  Address
                    VStack{
                        HStack{
                            WPTagContainer (tag: "Country") { AnyView(
                                WPTextField(placeholder: "Country", text: $country)
                            )}
                            .frame(minWidth: 125)
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
                    }
                    .onSubmit {
                        mapAPI.updateLocation(address: combineAddress(), delta: 0.004)
                    }
                    .padding([.bottom,.top])

                    Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations) { location in
                        MapMarker(coordinate: location.coordinate, tint: .blue)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.95)
                    .frame(alignment: .center)
                    .cornerRadius(5)
                    .shadow(radius: 4)
                }
                .onAppear {
                    if let iParkingspot = self.parkingspot {
                        setStateValues(parkingspot: iParkingspot)
                    }
                    mapAPI.updateLocation(address: combineAddress(), delta: 0.004)
                }
                .interactiveDismissDisabled()
                .padding()
            }
        }
    }
    
    private func close(){
        print("Close klicked.")
        dismiss()
    }

    private func save(){
        print("Save klicked.")
        saveParkingspot()
        dismiss()
    }
    
    private func dayDateToInt(dayAsDate: Date) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return Int(dateFormatter.string(from: dayAsDate))!
    }
    
    private func timeDateToInt(timeAsDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: timeAsDate)
        return ((components.hour ?? 0) * 60) + (components.minute ?? 0)
    }
    
    private func saveParkingspot(){
        guard let userid = wpvm.currentUser?._id else {fatalError("currentUser not set.")}
        var newWeekdays: [Int] = []
        for (index, isset) in weekdays.enumerated() {
            if isset {
                newWeekdays.append(index+1)
            }
        }
        let newAvailability = Timeframe(t_weekday: newWeekdays, t_dayfrom: dayDateToInt(dayAsDate: dayfrom), t_dayuntil: dayDateToInt(dayAsDate: dayuntil), t_timefrom: timeDateToInt(timeAsDate: timefrom), t_timeuntil: timeDateToInt(timeAsDate: timeuntil))
        let newAddress = Address(a_country: country, a_city: city, a_zip: zip, a_street: street, a_houseno: houseno, a_longitude: mapAPI.locations.first!.coordinate.longitude, a_latitude: mapAPI.locations.first!.coordinate.latitude)
        let newParkingspot = Parkingspot(_id: UUID().uuidString, p_owner: userid, p_number: no, p_priceperhour: Int(priceperhour)!, p_tags: tags, p_deleteflag: false, pt_availability: newAvailability, pr_reservations: [], pa_address: newAddress)
        if let currentParkingspot = parkingspot {
            if !currentParkingspot.issameas(newParkingspot: newParkingspot){
                if wpvm.updateParkingspot(parkingspotid: currentParkingspot._id, parkingspot: newParkingspot) {
                    print("Updated currentParkingspot.")
                }
            }else{
                print("Nothing changed.")
            }
        }else{
            if wpvm.addParkingspot(parkingspot: newParkingspot) {
                print("Added newParkingspot.")
            }
        }
    }

    private func combineAddress() -> String{
        return "\(street) \(houseno), \(zip) \(city), \(country)"
    }
}

struct ParkingspotEditTest: View{
    @State var parkingspot = Parkingspot.makeSampleParkingspot()!
    var body: some View{
        DashboardView()
            .environmentObject(WPViewModel())
//        ParkingspotEdit(parkingspot: parkingspot)
//            .environmentObject(WPapi())
    }
}

struct ParkingspotEdit_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotEditTest()
    }
}
