//
//  CarEdit.swift
//  WillParken
//
//  Created by Arbi Said on 28.02.23.
//

import SwiftUI

struct CarEdit: View {
    @EnvironmentObject var wpvm: WPViewModel
    @Environment(\.dismiss) var dismiss
    var car: Car?
    
    @State private var brand = ""
    @State private var model = ""
    @State private var licenceplate = ""
    
    init(car: Car? = nil){
        if let iCar = car {
            self.car = iCar
            setStateValues(car: iCar)
        }else{self.car = nil}
    }
    
    private func setStateValues(car: Car){
        brand = car.c_brand
        model = car.c_model
        licenceplate = car.c_licenceplate
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
                        WPTagContainer(tag: "Brand") { AnyView(
                            WPTextField(placeholder: "Brand", text: $brand)
                        )}
                        WPTagContainer(tag: "Model") { AnyView(
                            WPTextField(placeholder: "Model", text: $model)
                        )}
                        Spacer()
                        WPTagContainer(tag: "Licenceplate") { AnyView(
                            WPTextField(placeholder: "Licenceplate", text: $licenceplate)
                        )}
                    }
                    .padding([.bottom,.top])
                }
                .onAppear {
                    if let iCar = self.car {
                        setStateValues(car: iCar)
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
        saveCar()
        dismiss()
    }
    
    private func saveCar(){
        let newCar = Car(c_brand: brand, c_model: model, c_licenceplate: licenceplate)
        
        if let currentCar = car {
            if !currentCar.issameas(newCar: newCar) {
                newCar._id = currentCar._id
                wpvm.updateCar(car: newCar) { msg in
                    if let msg = msg {
                        print(msg)
                    }
                }
            } else {
                print("Nothing changed.")
            }
        }else{
            wpvm.addCar(car: newCar) { msg in
                if let msg = msg {
                    print(msg)
                }
            }
        }
    }
}

struct CarEditTest: View{
    @State var car = Car.makeSampleCar()!
    var body: some View{
        CarEdit(car: car)
            .environmentObject(WPViewModel())
    }
}

struct CarEdit_Previews: PreviewProvider {
    static var previews: some View {
        CarEditTest()
    }
}
