//
//  ParkingspotDataTemplate.swift
//  WillParken
//
//  Created by Arbi Said on 23.02.23.
//

import SwiftUI
import MapKit

struct ParkingspotEdit: View {
    @Environment(\.dismiss) var dismiss
    @Binding var parkingspot: Parkingspot
    @StateObject private var mapAPI = Mapapi()
    
    @State private var text = ""
    @State private var no = ""
    @State private var priceperhour = ""
    @State private var tags = ""
    @State private var weekday = ""
    @State private var dayfrom = Date()
    @State private var dayuntil = Date()
    @State private var timefrom = Date()
    @State private var timeuntil = Date()
    @State private var reservations = ""
    @State private var country = ""
    @State private var city = ""
    @State private var zip = ""
    @State private var street = ""
    @State private var houseno = ""
    
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
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "No") {
                                    AnyView(
                                        WPTextField(placeholder: "No", text: $no)
                                    )
                                }
                            }
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "Price / hour") {
                                    AnyView(
                                        WPTextField(placeholder: "Price", text: $priceperhour)
                                    )
                                }
                            }
                            Spacer()
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "Tags") {
                                    AnyView(
                                        WPTextField(placeholder: "Tags", text: $tags)
                                    )
                                }
                                .frame(minWidth: 200)
                            }
                        }
                    }
                    .padding([.bottom,.top])
                    
                    //  Availability
                    VStack(alignment:.leading){
                        WPTagContainer(tag: "Weekday") {
                            AnyView(
                                HStack{
                                    let weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                                    ForEach(weekdays, id: \.self) { day in
                                        Button {
                                            
                                        } label: {
                                            Text(day)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 25)
                                        .background(Color(red: 0.85, green: 0.85, blue: 1))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.75, green: 0.75, blue: 1)).blur(radius: 2))
                                    }
                                }
                            )
                        }
                        HStack{
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "Date from") {
                                    AnyView(
                                        DatePicker("",selection: $dayfrom, displayedComponents: .date)
                                            .labelsHidden()
                                    )
                                }
                            }
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "Date until") {
                                    AnyView(
                                        DatePicker("", selection: $dayuntil, displayedComponents: .date)
                                            .labelsHidden()
                                    )
                                }
                            }
                        }
                        HStack{
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "Time from") {
                                    AnyView(
                                        DatePicker("",selection: $dayfrom, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                    )
                                }
                            }
                            VStack(alignment:.leading){
                                WPTagContainer(tag: "Time until") {
                                    AnyView(
                                        DatePicker("",selection: $dayuntil, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                    )
                                }
                            }
                        }
                    }
                    .padding([.bottom,.top])
                    
                    //  Address
                    VStack{
                        HStack{
                            WPTagContainer (tag: "Country") {
                                AnyView(
                                    WPTextField(placeholder: "Country", text: $country)
                                )
                            }
                            .frame(minWidth: 125)
                            WPTagContainer (tag: "City") {
                                AnyView(
                                    WPTextField(placeholder: "City", text: $city)
                                )
                            }
                            .frame(minWidth: 125)
                            WPTagContainer (tag: "ZIP") {
                                AnyView(
                                    WPTextField(placeholder: "ZIP", text: $zip)
                                )
                            }
                        }
                        HStack{
                            WPTagContainer (tag: "Street") {
                                AnyView(
                                    WPTextField(placeholder: "Street", text: $street)
                                )
                            }
                            .frame(minWidth: 250)
                            WPTagContainer (tag: "Houseno") {
                                AnyView(
                                    WPTextField(placeholder: "Houseno", text: $houseno)
                                )
                            }
                        }
                    }
                    .onSubmit {
                        mapAPI.updateLocation(address: stringifyAddress(), delta: 0.004)
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
                    setup()
                    mapAPI.updateLocation(address: stringifyAddress(), delta: 0.004)
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
        dismiss()
    }
    
    private func stringifyAddress() -> String{
        return "\(street) \(houseno), \(zip) \(city), \(country)"
    }
    
    private func setup(){
        no = String(parkingspot.p_number)
        priceperhour = parkingspot.p_priceperhour
        tags = ""
        weekday = ""
        dayfrom = Date()
        dayuntil = Date()
        timefrom = Date()
        timeuntil = Date()
        reservations = ""
        country = parkingspot.pa_address.a_country
        city = parkingspot.pa_address.a_city
        zip = parkingspot.pa_address.a_zip
        street = parkingspot.pa_address.a_street
        houseno = parkingspot.pa_address.a_houseno
    }
}

struct ParkingspotEditTest: View{
    @State var parkingspot = Parkingspot(_id: "1", p_number: 1)
    var body: some View{
        ParkingspotEdit(parkingspot: $parkingspot)
    }
}

struct ParkingspotEdit_Previews: PreviewProvider {
    static var previews: some View {
        ParkingspotEditTest()
    }
}
