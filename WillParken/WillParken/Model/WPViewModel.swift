//
//  WPViewModel.swift
//  WillParken
//
//  Created by Arbi Said on 05.03.23.
//

import Foundation

class WPViewModel: ObservableObject {
    @Published var wpapi: WPapi = WPapi()
    
    @Published var currentUser: User?
    @Published var currentParkingspots: [Parkingspot]?
    @Published var searchedParkingspots: [Parkingspot]? = Parkingspot.makeSampleParkingspotArray()
    
    
    //  MARK: User
    public func loginUser(iUsername: String, iPassword: String) {
//        self.currentUser = User.makeSampleUser()
        wpapi.loginUser(iUsername: iUsername, iPassword: iPassword){ reUser in
            self.currentUser = reUser
        }
    }
    
    public func getUser() {
        wpapi.getUser(){ reUser in
            self.currentUser = reUser
        }
    }
    
    public func registerUser(iUsername: String, iEmail: String, iFirstname: String, iLastname: String, iPassword: String) {
        wpapi.registerUser(iUsername: iUsername, iEmail: iEmail, iFirstname: iFirstname, iLastname: iLastname, iPassword: iPassword) { reUser in
            self.currentUser = reUser
        }
    }
    
    
    //  MARK: Parkingspot
    public func loadParkingspotsFromUser() {
//        self.currentParkingspots = Parkingspot.makeSampleParkingspotArray()
        wpapi.loadParkingspotsFromUser(){ reParkingspots in
            self.currentParkingspots = reParkingspots
        }
    }
    
    public func addParkingspot(parkingspot: Parkingspot) -> Bool {
        return false
    }
    
    public func updateParkingspot(parkingspotid: String, parkingspot: Parkingspot) -> Bool {
        return false
    }
    
    public func deleteParkingspot(p_id: String) -> Bool {
        return false
    }
    
    public func searchParkingspots(){
        
    }
    
    
    //  MARK: Car
    public func loadCarsFromUser(){
        wpapi.loadCarsFromUser { reCars in
            if let iReCars = reCars {
                self.currentUser?.uc_cars = iReCars
            }
        }
    }
    
    public func addCar() -> Bool {
        return false
    }
    
    public func updateCar() -> Bool {
        return false
    }
    
    public func deleteCar() -> Bool {
        return false
    }
}
