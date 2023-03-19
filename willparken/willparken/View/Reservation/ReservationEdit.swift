//
//  ReservationEdit.swift
//  WillParken
//
//  Created by Arbi Said on 12.03.23.
//

import SwiftUI

struct ReservationEdit: View {
    
    @EnvironmentObject var wpvm: WPViewModel
    @Environment(\.dismiss) var dismiss
    
    public var parkingspot: Parkingspot
    
    @State private var carid: String = ""
    @State private var weekdays: [Int] = []
    @State private var weekdaysArray = [false,false,false,false,false,false,false]
    @State private var dayfrom: Date = Date()
    @State private var dayuntil: Date = Date()
    @State private var timefrom: Date = Date()
    @State private var timeuntil: Date = Date()
    
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var errorMsg: String = ""
    
    init(parkingspot: Parkingspot) {
        self.parkingspot = parkingspot
        self.weekdays = parkingspot.pt_availability.t_weekday
        self.dayfrom = parkingspot.pt_availability.dayfromAsDate
        self.dayuntil = parkingspot.pt_availability.dayuntilAsDate
        self.timefrom = parkingspot.pt_availability.timefromAsDate
        self.timeuntil = parkingspot.pt_availability.timeuntilAsDate
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("Reservierung aufgeben")
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            Divider()
            ScrollView {
                VStack{
                    //  Availability
                    VStack(alignment:.leading){
                        WPTagContainer(tag: "Wochentage") { AnyView(
                            HStack{
                                ForEach(0..<7) { index in
                                    WeekdayButtonView(dayIndex: index, isActive: $weekdaysArray[index])
                                }
                            }
                        )}
                        HStack{
                            WPTagContainer(tag: "Datum von") { AnyView(
                                DatePicker("",selection: $dayfrom, in: parkingspot.pt_availability.dayfromAsDate...parkingspot.pt_availability.dayuntilAsDate, displayedComponents: .date)
                                    .labelsHidden()
                            )}
                            WPTagContainer(tag: "Datum bis") { AnyView(
                                DatePicker("", selection: $dayuntil, in: parkingspot.pt_availability.dayfromAsDate...parkingspot.pt_availability.dayuntilAsDate, displayedComponents: .date)
                                    .labelsHidden()
                            )}
                        }
                        HStack{
                            WPTagContainer(tag: "Uhrzeit von") { AnyView(
                                DatePicker("",selection: $timefrom, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            )}
                            WPTagContainer(tag: "Uhrzeit bis") { AnyView(
                                DatePicker("",selection: $timeuntil, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            )}
                        }
                    }
                    .padding([.bottom,.top])
                }
                .padding(.horizontal)
                VStack{
                    //  Car Picker
                    WPTagContainer (tag: "Fahrzeug") { AnyView(
                        Picker(selection: $carid, label: Text("Fahrzeug")) {
                            if let cars = wpvm.currentUser?.uc_cars{
                                ForEach(cars){ car in
                                    Text("\(car.c_licenceplate)").tag(car._id)
                                }
                                .onAppear{
                                    if let firstcar = cars.first{
                                        carid = firstcar._id
                                    }
                                }
                            }
                        }
                            .pickerStyle(.wheel)
                    )}
                    .frame(height: 100)
                }
                .padding([.horizontal,.bottom])
                VStack{
                    WPButton(backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.85), foregroundColor: .white, label: "Reservieren") {
                        makeReservation()
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.5 : 1)
        .onAppear{
            self.weekdays = parkingspot.pt_availability.t_weekday
            self.dayfrom = parkingspot.pt_availability.dayfromAsDate
            self.dayuntil = parkingspot.pt_availability.dayuntilAsDate
            self.timefrom = parkingspot.pt_availability.timefromAsDate
            self.timeuntil = parkingspot.pt_availability.timeuntilAsDate
            for dayIndex in parkingspot.pt_availability.t_weekday {
                weekdaysArray[dayIndex-1].toggle()
            }
        }
        .alert(isPresented: $isError) {
            Alert(title: Text("Oh nein!"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
        }
        .overlay(
            ZStack{
                if isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        )
    }
    
    private func makeReservation(){
        
        var newWeekdays: [Int] = []
        for (index, isset) in weekdaysArray.enumerated() {
            if isset {
                newWeekdays.append(index+1)
            }
        }
        
        guard Set(newWeekdays).isSubset(of: Set(parkingspot.pt_availability.t_weekday) as! Set<AnyHashable>) else {
            errorMsg = "Der Parkplatz ist an diesen Wochentagen nicht verfügbar."
            isError = true
            return
        }
        
        isLoading = true
        wpvm.makeReservation(parkingspotid: parkingspot._id, carid: carid, timeframe: makeTimeframe()) { msg in
            isLoading = false
            if let msg = msg {
                print(msg)
                dismiss()
            }
        } failure: { err in
            isLoading = false
            if let err = err {
                if err.starts(with: "400 Car") {
                    errorMsg = "Das Fahrzeug ist zu dieser Zeit nicht verfügbar."
                    isError = true
                    print(err)
                }
            }
        }
    }
    
    private func makeTimeframe() -> Timeframe{
        print(carid)
        return Timeframe(t_weekday: [], t_dayfrom: dayfrom, t_dayuntil: dayuntil, t_timefrom: timefrom, t_timeuntil: timeuntil)
    }
}

struct ReservationEdit_Previews: PreviewProvider {
    static var previews: some View {
        ReservationEdit(parkingspot: Parkingspot.makeSampleParkingspot()!)
            .environmentObject(WPViewModel())
    }
}
