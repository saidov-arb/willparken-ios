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
    @State private var no = "22"
    @State private var priceperhour = 1
    @State private var status = "active"
    @State private var tagsArray = [false,false,false,false,false]
    @State private var tagsArrayNames = ["Roof","Gate","Indoor","E-Charger","Security"]
    @State private var weekdays = [false,false,false,false,false,false,false]
    @State private var dayfrom = Date()
    @State private var dayuntil = Date()
    @State private var timefrom = Date()
    @State private var timeuntil = Date()
    @State private var country = "Austria"
    @State private var city = "Wels"
    @State private var zip = "4600"
    @State private var street = "Kamerlweg"
    @State private var houseno = "21a"
    @State private var currentCoordinate: EquatableCoordinate?
    
    init(parkingspot: Parkingspot? = nil){
        if let iParkingspot = parkingspot {
            self.parkingspot = iParkingspot
        }else{self.parkingspot = nil}
    }
    
    private func setStateValues(parkingspot: Parkingspot){
        no = String(parkingspot.p_number)
        priceperhour = parkingspot.p_priceperhour
        for dayIndex in parkingspot.pt_availability.t_weekday {
            weekdays[dayIndex-1].toggle()
        }
        for setTag in parkingspot.p_tags {
            for (index,value) in tagsArrayNames.enumerated() {
                if setTag == value {
                    tagsArray[index] = true
                }
            }
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
        status = parkingspot.p_status
        if parkingspot.pa_address.a_latitude != 0 && parkingspot.pa_address.a_longitude != 0 {
            currentCoordinate = EquatableCoordinate(coordinate: CLLocationCoordinate2D(latitude: parkingspot.pa_address.a_latitude, longitude: parkingspot.pa_address.a_longitude))
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center){
                Button {
                    save()
                } label: {
                    Text("Save")
                }
                .disabled(status == "deleted")
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
                                WPStepper(value: $priceperhour, in: 0...50)
                            )}
                            WPTagContainer(tag: "Status") { AnyView(
                                WPStatusToggle(isActive: Binding(get: {
                                    self.status == "active"
                                }, set: { newValue in
                                    if self.status != "deleted" {
                                        if newValue {
                                            self.status = "active"
                                        } else {
                                            self.status = "inactive"
                                        }
                                    }
                                }), text: status.capitalized, height: 45)
                            )}
                        }
                        HStack{
                            WPTagContainer(tag: "Tags") { AnyView(
                                VStack{
                                    HStack{
                                        ForEach (0..<3){ index in
                                            WPStatusToggle(isActive: $tagsArray[index], text: tagsArrayNames[index], maxWidth: 120)
                                        }
                                    }
                                    HStack{
                                        ForEach (3..<5){ index in
                                            WPStatusToggle(isActive: $tagsArray[index], text: tagsArrayNames[index], maxWidth: 120)
                                        }
                                    }
                                }
                            )}
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
                        }
                        .onSubmit {
                            mapAPI.setLocationWithAddress(address: combineAddress(), delta: 0.004)
                        }
                        .padding(.bottom)
                        
                        Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations) { location in
                            MapMarker(coordinate: location.coordinate, tint: .blue)
                        }
                        .onChange(of: EquatableCoordinate(coordinate: mapAPI.region.center)) { newCenter in
                            currentCoordinate = newCenter
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.95)
                        .frame(alignment: .center)
                        .cornerRadius(5)
                        .shadow(radius: 4)
                        .overlay(
                            ZStack {
                                if currentCoordinate != nil {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.purple)
                                        .fontWeight(.bold)
                                        .imageScale(.large)
                                        .shadow(radius: 4)
                                }
                            },
                            alignment: .center
                        )
                        .overlay(
                            ZStack{
                                Button{
                                    if let currentCoordinate = currentCoordinate {
                                        mapAPI.setLocationWithCoordinates(coordinates: currentCoordinate.coordinate, delta: 0.004)
                                    }
                                } label: {
                                    Image(systemName: "mappin.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                }
                                .padding(.trailing,7)
                                .padding(.bottom,25)
                            },
                            alignment: .bottomTrailing
                        )
                    }
                    .padding(.top)
                    
                }
                .onAppear {
                    if let iParkingspot = self.parkingspot {
                        setStateValues(parkingspot: iParkingspot)
                    }
                    if let currentCoordinate = currentCoordinate {
                        mapAPI.setLocationWithCoordinates(coordinates: currentCoordinate.coordinate, delta: 0.004)
                    }else{
                        mapAPI.setLocationWithAddress(address: combineAddress(), delta: 0.004)
                    }
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
        var newTags: [String] = []
        for (index, isset) in weekdays.enumerated() {
            if isset {
                newWeekdays.append(index+1)
            }
        }
        for (index, isset) in tagsArray.enumerated() {
            if isset {
                newTags.append(tagsArrayNames[index])
            }
        }
        let newAvailability = Timeframe(t_weekday: newWeekdays, t_dayfrom: dayDateToInt(dayAsDate: dayfrom), t_dayuntil: dayDateToInt(dayAsDate: dayuntil), t_timefrom: timeDateToInt(timeAsDate: timefrom), t_timeuntil: timeDateToInt(timeAsDate: timeuntil))
        let newAddress = Address(a_country: country, a_city: city, a_zip: zip, a_street: street, a_houseno: houseno, a_longitude: currentCoordinate?.coordinate.longitude ?? 0, a_latitude: currentCoordinate?.coordinate.latitude ?? 0)
        let newParkingspot = Parkingspot(p_owner: userid, p_number: no, p_priceperhour: priceperhour, p_status: status, p_tags: newTags, pt_availability: newAvailability, pa_address: newAddress)
        if let currentParkingspot = parkingspot {
            if !currentParkingspot.issameas(newParkingspot: newParkingspot){
                newParkingspot._id = currentParkingspot._id
                wpvm.updateParkingspot(parkingspot: newParkingspot) { msg in
                    if let msg = msg {
                        print(msg)
                    }
                }
            }else{
                print("Nothing changed.")
            }
        }else{
            wpvm.addParkingspot(parkingspot: newParkingspot) { msg in
                if let msg = msg {
                   print(msg)
                }
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
//        DashboardView()
//            .environmentObject(WPViewModel())
        ParkingspotEdit(parkingspot: parkingspot)
            .environmentObject(WPViewModel())
    }
}

struct ParkingspotEdit_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotEditTest()
    }
}
