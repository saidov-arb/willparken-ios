import UIKit
import CommonCrypto

//func sha256(_ input: String) -> String {
//    let data = Data(input.utf8)
//    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//    data.withUnsafeBytes {
//        _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
//    }
//    return hash.map { String(format: "%02x", $0) }.joined()
//}
//
//print(sha256("password"))   // 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
//print(sha256("dings"))      // eea121c23968675a9c3a92134326a960fa578a7f6acd755e6b5339b12b95a221
//print(sha256("admin1234"))  // ac9689e2272427085e35b9d3e3e8bed88cb3434828b43b86fc0596cad4c6e270


//var user = User.makeSampleUser()
//var car = Car.makeSampleCar()
//var parkingspot = Parkingspot.makeSampleParkingspot()
//var address = Address.makeSampleAddress()
//var timeframe = Timeframe.makeSampleTimeframe()
//var reservation = Reservation.makeSampleReservation()
//var parkingspotArray = Parkingspot.makeSampleParkingspotArray()
//
//print(user?.u_email ?? "nouser")
//print(car?.c_brand ?? "nocar")
//print(parkingspot?.p_priceperhour ?? "noparkingspot")
//print(address?.a_country ?? "noaddress")
//print(timeframe?.timefromAsString ?? "notimeframe")
//print(reservation?.ru_user ?? "noreservation")
//if let parkingspotArray = parkingspotArray{
//    for iParkingspot in parkingspotArray {
//        print("Parkinspot bei: ",iParkingspot.pa_address.a_street)
//    }
//}else{print("noparkingspotArray")}

var wpvm = WPViewModel()

wpvm.getUser()
if wpvm.currentUser == nil {
    wpvm.loginUser(iUsername: "saidov-arb", iPassword: "password")
}

wpvm.loadParkingspotsFromUser()

//var parkingspot = Parkingspot(_id: "10", p_number: 10)
//
//var refParkingspot = parkingspot
//
//refParkingspot.p_priceperhour = "187"
//
//print(parkingspot.p_priceperhour)
