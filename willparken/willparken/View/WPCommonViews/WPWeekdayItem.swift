//
//  WPWeekdayItem.swift
//  WillParken
//
//  Created by Arbi Said on 27.02.23.
//

import SwiftUI

struct WeekdayButtonView: View {
    var dayIndex: Int
    @Binding var isActive: Bool
    var body: some View{
        Button {
            isActive.toggle()
        } label: {
            WeekdayView(dayIndex: dayIndex, background: isActive ? Color(red: 0.85, green: 0.85, blue: 1) : Color.gray.opacity(0.05))
        }
    }
}

struct WeekdayView: View {
    var dayIndex: Int
    var background: Color = Color(red: 0.85, green: 0.85, blue: 1)
    private let weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So", "Jeden Tag"]
    var body: some View {
        Text(weekdays[dayIndex])
            .frame(maxWidth: .infinity)
            .frame(height: 25)
            .background(background)
            .foregroundColor(.black)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.75, green: 0.75, blue: 1)).blur(radius: 2))
    }
}

struct WeekdayViewTest: View {
    @State private var isActive = false
    var body: some View{
        VStack{
            WeekdayView(dayIndex: 0)
            WeekdayButtonView(dayIndex: 1, isActive: $isActive)
        }
    }
}

struct WPWeekdayItem_Previews: PreviewProvider {
    static var previews: some View {
        WeekdayViewTest()
    }
}
