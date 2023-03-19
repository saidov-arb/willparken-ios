//
//  WPViewModel.swift
//  WillParken
//
//  Created by Arbi Said on 05.03.23.
//

import Foundation

class WPViewModel: ObservableObject {
    private var wpapi: WPapi = WPapi()
    
    @Published var currentUser: User?
//    @Published var currentUser: User? = User.makeSampleUser()!
    @Published var currentParkingspots: [Parkingspot]?
    @Published var currentReservations: [Reservation]?
    @Published var searchedParkingspots: [Parkingspot]?
    
    
    //  MARK: - User -
    public func loginUser(iUsername: String, iPassword: String, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void) {
        //  At first, the data has to be organized in a struct
        struct LoginDataStruct: Encodable {
            let u_username: String
            let u_password: String
        }
        let loginData = LoginDataStruct(u_username: iUsername, u_password: wpapi.sha256(iPassword))
        //  Now just login the user (loginData will be converted to JSON inside the method)
        wpapi.postDecodableObject(apiroute: "/users/login", httpmethod: HTTPMethod.POST, objectToSend: loginData) { (response: User?) in
            if let response = response {
                self.currentUser = response
                success("Logged in User.")
            }
        } failure: { (error: String?) in
            if let error = error {
                failure(error)
            }
        }
    }
    
    public func registerUser(iUsername: String, iEmail: String, iFirstname: String, iLastname: String, iPassword: String, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void){
        struct RegisterDataStruct: Encodable {
            let u_username: String
            let u_email: String
            let u_firstname: String
            let u_lastname: String
            let u_password: String
        }
        let registerData = RegisterDataStruct(u_username: iUsername, u_email: iEmail, u_firstname: iFirstname, u_lastname: iLastname, u_password: wpapi.sha256(iPassword))
        wpapi.postDecodableObject(apiroute: "/users/register", httpmethod: HTTPMethod.POST, objectToSend: registerData) { (response: User?) in
            if let response = response {
                self.currentUser = response
                success("Registered User.")
            }
        } failure: { (error: String?) in
            if var error = error {
                if error.starts(with: "400") {
                    error = "Benutzername bereits vergeben."
                }
                failure(error)
            }
        }
    }
    
    public func logoutUser(){
        wpapi.fetchDecodableObject(apiroute: "/users/logout") { (response: String?) in
            if response != nil {
                print("Logged Out User.")
                self.currentUser = nil
                self.currentParkingspots = nil
                self.searchedParkingspots = nil
                self.currentReservations = nil
            }
        }
    }
    
    public func getUser(success: @escaping (String?) -> Void){
        wpapi.fetchDecodableObject(apiroute: "/users/getUser") { (response: User?) in
            if let response = response {
                self.currentUser = response
                success("Loaded User.")
            }
        }
    }
    
    public func updateUser(firstname: String, lastname: String, email: String, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void){
        struct UpdateUserStruct: Encodable {
            let u_firstname: String
            let u_lastname: String
            let u_email: String
        }
        let updateUserData = UpdateUserStruct(u_firstname: firstname, u_lastname: lastname, u_email: email)
        wpapi.postDecodableObject(apiroute: "/users/update", httpmethod: HTTPMethod.PATCH, objectToSend: updateUserData) { (response: User?) in
            if let response = response {
                self.currentUser = response
                success("Updated User")
            }
        } failure: { (error: String?) in
            if let error = error {
                failure(error)
            }
        }
    }
    
    public func addUserMoney(money:Int, success: @escaping (String?) -> Void){
        struct AddUserMoneyStruct: Encodable {
            let money: Int
        }
        let addUserMoneyData = AddUserMoneyStruct(money: money)
        wpapi.postDecodableObject(apiroute: "/users/addMoney", httpmethod: HTTPMethod.POST, objectToSend: addUserMoneyData) { (response: User?) in
            if let response = response{
                self.currentUser = response
                success("Successfully added Money.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }

    }
    
    
    //  MARK: - Parkingspot -
    public func loadParkingspotsFromUser() {
        wpapi.fetchDecodableObject(apiroute: "/parkingspots/getParkingspots") { (response: [Parkingspot]?) in
            if let response = response {
                self.currentParkingspots = response
            }
        }
    }
    
    public func addParkingspot(parkingspot: Parkingspot, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void) {
        struct ParkingspotAddStruct: Encodable {
            let p_tags: [String]
            let p_number: String
            let pt_availability: Timeframe
            let p_priceperhour: Int
            let pa_address: Address
        }
        let parkingspotAddData = ParkingspotAddStruct(p_tags: parkingspot.p_tags, p_number: parkingspot.p_number, pt_availability: parkingspot.pt_availability, p_priceperhour: parkingspot.p_priceperhour, pa_address: parkingspot.pa_address)
        wpapi.postDecodableObject(apiroute: "/parkingspots/add", httpmethod: HTTPMethod.POST, objectToSend: parkingspotAddData) { (response: Parkingspot?) in
            if response != nil {
                success("Added Parkingspot")
            }
        } failure: { (error: String?) in
            if let error = error {
                failure(error)
            }
        }
    }
    
    public func updateParkingspot(parkingspot: Parkingspot, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void) {
        struct ParkingspotUpdateStruct: Encodable {
            let p_id: String
            let p_tags: [String]
            let p_number: String
            let pt_availability: Timeframe
            let p_priceperhour: Int
            let pa_address: Address
            let p_status: String
        }
        let parkingspotUpdateData = ParkingspotUpdateStruct(p_id: parkingspot._id, p_tags: parkingspot.p_tags, p_number: parkingspot.p_number, pt_availability: parkingspot.pt_availability, p_priceperhour: parkingspot.p_priceperhour, pa_address: parkingspot.pa_address, p_status: parkingspot.p_status)
        
        wpapi.postDecodableObject(apiroute: "/parkingspots/update", httpmethod: HTTPMethod.PATCH, objectToSend: parkingspotUpdateData) { (response: Parkingspot?) in
            if response != nil {
                success("Updated Parkingspot.")
            }
        } failure: { (error: String?) in
            if let error = error {
                failure(error)
            }
        }
    }
    
    public func deleteParkingspot(parkingspotid: String, success: @escaping (String?) -> Void) {
        struct ParkingspotDeleteStruct: Encodable {
            let p_id: String
        }
        let parkingspotDeleteData = ParkingspotDeleteStruct(p_id: parkingspotid)
        wpapi.postDecodableObject(apiroute: "/parkingspots/delete", httpmethod: HTTPMethod.DELETE, objectToSend: parkingspotDeleteData) { (response: String?) in
            if response != nil {
                success("Deleted Parkingspot.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    public func searchParkingspots(address: Address, success: @escaping (String?) -> Void) {
        struct ParkingspotSearchStruct: Encodable {
            let pa_address: Address
        }
        let parkingspotSearchData = ParkingspotSearchStruct(pa_address: address)
        wpapi.postDecodableObject(apiroute: "/parkingspots/search", httpmethod: HTTPMethod.POST, objectToSend: parkingspotSearchData) { (response: [Parkingspot]?) in
            if let response = response {
                self.searchedParkingspots = response
                for ps in self.searchedParkingspots! {
                    print(ps.pa_address.a_street)
                }
                success("Found Parkingspots.")
            } else {
                success("Found no Parkingspots.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    public func getSearchedParkingspotsMAddressArray() -> [MAddress]{
        var maddressArray: [MAddress] = []
        if let pss = searchedParkingspots{
            for ips in pss {
                let mdata = [MData(latitude: ips.pa_address.a_latitude, longitude: ips.pa_address.a_longitude, name: "Pin")]
                let maddress = MAddress(data: mdata)
                maddressArray.append(maddress)
            }
        } else {
            print("No Parkingspots in searchedParkingspots array.")
        }
        return maddressArray
    }
    
    
    //  MARK: - Car -
    public func loadCarsFromUser() {
        wpapi.fetchDecodableObject(apiroute: "/users/getCars") { (response: [Car]?) in
            if let response = response {
                self.currentUser?.uc_cars = response
            }
        }
    }
    
    public func addCar(car: Car, success: @escaping (String?) -> Void) {
        struct CarAddSubStruct: Encodable {
            let c_brand: String
            let c_model: String
            let c_licenceplate: String
        }
        struct CarAddStruct: Encodable {
            let c_car: CarAddSubStruct
        }
        let carAddData = CarAddStruct(c_car: CarAddSubStruct(c_brand: car.c_brand, c_model: car.c_model, c_licenceplate: car.c_licenceplate))
        wpapi.postDecodableObject(apiroute: "/users/addCar", httpmethod: HTTPMethod.POST, objectToSend: carAddData) { (response: Car?) in
            if response != nil {
                success("Added Car.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    public func updateCar(car: Car, success: @escaping (String?) -> Void) {
        struct CarUpdateSubStruct: Encodable {
            let c_id: String
            let c_brand: String
            let c_model: String
            let c_licenceplate: String
        }
        struct CarUpdateStruct: Encodable {
            let c_car: CarUpdateSubStruct
        }
        let carUpdateData = CarUpdateStruct(c_car: CarUpdateSubStruct(c_id: car._id, c_brand: car.c_brand, c_model: car.c_model, c_licenceplate: car.c_licenceplate))
        wpapi.postDecodableObject(apiroute: "/users/updateCar", httpmethod: HTTPMethod.PATCH, objectToSend: carUpdateData) { (response: Car?) in
            if response != nil {
                success("Updated Car.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    public func deleteCar(carid: String, success: @escaping (String?) -> Void) {
        struct CarDeleteSubStruct: Encodable {
            let c_id: String
        }
        struct CarDeleteStruct: Encodable {
            let c_car: CarDeleteSubStruct
        }
        let carDeleteData = CarDeleteStruct(c_car: CarDeleteSubStruct(c_id: carid))
        wpapi.postDecodableObject(apiroute: "/users/deleteCar", httpmethod: HTTPMethod.DELETE, objectToSend: carDeleteData) { (response: User?) in
            if response != nil {
                success("Deleted Car.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    //  MARK: - Reservation -
    public func makeReservation(parkingspotid: String, carid: String, timeframe: Timeframe, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void){
        struct ReservationMakeSubStruct: Encodable {
            let rc_car: String
            let rt_timeframe: Timeframe
        }
        struct ReservationMakeStruct: Encodable {
            let p_id: String
            let pr_reservation: ReservationMakeSubStruct
        }
        let reservationMakeData = ReservationMakeStruct(p_id: parkingspotid, pr_reservation: ReservationMakeSubStruct(rc_car: carid, rt_timeframe: timeframe))
        wpapi.postDecodableObject(apiroute: "/parkingspots/makeReservation", httpmethod: HTTPMethod.POST, objectToSend: reservationMakeData) { (response: String?) in
            if response != nil {
                success("Reservation added.")
            }
        } failure: { (error: String?) in
            if let error = error {
                failure(error)
            }
        }

    }
    
    public func cancelReservation(parkingspotid: String, reservationid: String, success: @escaping (String?) -> Void, failure: @escaping (String?) -> Void){
        struct ReservationDeleteSubStruct: Encodable {
            let r_id: String
        }
        struct ReservationDeleteStruct: Encodable {
            let p_id: String
            let pr_reservation: ReservationDeleteSubStruct
        }
        print("pid: \(parkingspotid) - rid: \(reservationid)")
        let reservationDeleteData = ReservationDeleteStruct(p_id: parkingspotid, pr_reservation: ReservationDeleteSubStruct(r_id: reservationid))
        wpapi.postDecodableObject(apiroute: "/parkingspots/cancelReservation", httpmethod: HTTPMethod.PATCH, objectToSend: reservationDeleteData) { (response: String?) in
            if let response = response {
                success(response)
            }
        } failure: { (error: String?) in
            if let error = error {
                failure(error)
            }
        }
    }
    
    public func loadReservationsFromUser(){
        wpapi.fetchDecodableObject(apiroute: "/parkingspots/getReservations") { (response: [Reservation]?) in
            if let response = response {
                self.currentReservations = response
            }
        }
    }
}
