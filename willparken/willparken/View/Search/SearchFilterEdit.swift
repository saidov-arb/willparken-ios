//
//  SearchFilterEdit.swift
//  WillParken
//
//  Created by Arbi Said on 11.03.23.
//

import SwiftUI

struct SearchFilterEdit: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding public var useFilters: Bool
    @Binding public var priceperhour: Int
    @Binding public var tags: [String]
    @Binding public var weekdays: [Int]
    @State private var tagsArray = [false,false,false,false,false]
    @State private var tagsArrayNames = ["Roof","Gate","Indoor","E-Charger","Security"]
    @State private var weekdaysArray = [false,false,false,false,false,false,false]
    @Binding public var dayfrom: Date
    @Binding public var dayuntil: Date
    @Binding public var timefrom: Date
    @Binding public var timeuntil: Date
    
    var body: some View {
        ScrollView {
            VStack{
                VStack{
                    VStack(alignment: .leading){
                        HStack{
                            WPTagContainer(tag: "Max Price / hour") { AnyView(
                                WPStepper(value: $priceperhour, in: 0...50)
                            )}
                            .disabled(!useFilters)
                            .opacity(!useFilters ? 0.3 : 1)
                            Spacer()
                            WPTagContainer(tag: "Use Filters?") {AnyView(
                                WPStatusToggle(isActive: $useFilters, text: useFilters ? "Yes" : "No", height: 45)
                            )}
                            .frame(maxWidth: 100)
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
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
                    .disabled(!useFilters)
                    .opacity(!useFilters ? 0.3 : 1)
                }
                .padding([.bottom,.top])
                
                //  Availability
                VStack(alignment:.leading){
                    WPTagContainer(tag: "Weekday") { AnyView(
                        HStack{
                            ForEach(0..<7) { index in
                                WeekdayButtonView(dayIndex: index, isActive: $weekdaysArray[index])
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
                .disabled(!useFilters)
                .opacity(!useFilters ? 0.3 : 1)
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .onDisappear{
            fixTags()
            fixWeekdays()
        }
        .onAppear{
            setTags()
            setWeekdays()
        }
    }
    
    private func fixTags(){
        var newTags: [String] = []
        for (index, isset) in tagsArray.enumerated() {
            if isset {
                newTags.append(tagsArrayNames[index])
            }
        }
        tags = newTags
    }
    
    private func fixWeekdays(){
        var newWeekdays: [Int] = []
        for (index, isset) in weekdaysArray.enumerated() {
            if isset {
                newWeekdays.append(index+1)
            }
        }
        weekdays = newWeekdays
    }
    
    private func setTags(){
        for setTag in tags {
            for (index,value) in tagsArrayNames.enumerated() {
                if setTag == value {
                    tagsArray[index] = true
                }
            }
        }
    }
    
    private func setWeekdays(){
        for dayIndex in weekdays {
            weekdaysArray[dayIndex-1].toggle()
        }
    }
}

struct SearchFilterEditTest : View {
    @State private var useFilters = false
    @State private var priceperhour = 5
    @State private var tags = ["Gate"]
    @State private var weekdays = [1,2]
    @State private var dayfrom = Date()
    @State private var dayuntil = Date()
    @State private var timefrom = Date()
    @State private var timeuntil = Date()
    
    var body: some View {
        SearchFilterEdit(useFilters: $useFilters, priceperhour: $priceperhour, tags: $tags, weekdays: $weekdays, dayfrom: $dayfrom, dayuntil: $dayuntil, timefrom: $timefrom, timeuntil: $timeuntil)
    }
}

struct SearchFilterEdit_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterEditTest()
    }
}
