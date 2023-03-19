//
//  WPStepper.swift
//  WillParken
//
//  Created by Arbi Said on 06.03.23.
//
//  Source: https://talk.objc.io/episodes/S01E321-custom-components-creating-a-custom-stepper

import SwiftUI

struct WPStepper: View {
    var steps: Int = 1
    @Binding var value: Int
    var `in`: ClosedRange<Int>
    
    @Environment(\.controlSize)
    var controlSize
    
    var padding: Double {
        switch controlSize {
        case .mini: return 4
        case .small: return 6
        case .large: return 30
        default: return 8
        }
    }
        
    var body: some View {
        HStack {
            Button { value -= value == `in`.lowerBound ? 0 : steps } label: {
                Image(systemName: "minus")
            }
            Text(value.formatted())
                .frame(minWidth: 25)
            Button { value += value == `in`.upperBound ? 0 : steps } label: {
                Image(systemName: "plus")
            }
        }
        .transformEnvironment(\.font, transform: { font in
            if font != nil { return }
            switch controlSize {
            case .mini: font = .footnote
            case .small: font = .callout
            case .large: font = .largeTitle
            default: font = .body
            }

        })
        .frame(minHeight: 30)
        .padding(.vertical, padding)
        .padding(.horizontal, padding * 2)
        .foregroundColor(.black)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple.opacity(0.05))
        }
    }
}

struct WPStepperTest: View{
    @State var value = 0
    var body: some View {
        WPStepper(value: $value, in: 0...50)
    }
}

struct WPStepper_Previews: PreviewProvider {
    static var previews: some View {
        WPStepperTest()
    }
}
