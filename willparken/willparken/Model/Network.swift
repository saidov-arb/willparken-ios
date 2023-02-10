//
//  Network.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//
//
//  https://designcode.io/swiftui-advanced-handbook-http-request

import Foundation
import CommonCrypto

class Network: ObservableObject{
    @Published var users: [User]? = []
    @Published var parkingspots: [Parkingspot]? = []
    @Published var actualUser: User? = nil
    
    private final var APIURL: String = "http://localhost:3000"
    
    func loginUser(iUsername: String, iPassword: String){
        //  At first, the data has to be organized in a struct
        struct LoginDataStruct: Encodable {
            let u_username: String
            let u_password: String
        }
        let loginData = LoginDataStruct(u_username: iUsername, u_password: sha256(iPassword))
        //  Now just login the user (loginData will be converted to JSON inside the method)
        postDecodableObject(apiroute: "/users/login", httpmethod: HTTPMethod.POST, objectToSend: loginData) { (response: User?) in
            if let response = response {
                self.actualUser = response
                print(self.actualUser!.u_email)
            } else {
                print("Katastrophe.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func registerUser(iUsername: String, iEmail: String, iFirstname: String, iLastname: String, iPassword: String){
        struct RegisterDataStruct: Encodable {
            let u_username: String
            let u_email: String
            let u_firstname: String
            let u_lastname: String
            let u_password: String
        }
        let registerData = RegisterDataStruct(u_username: iUsername, u_email: iEmail, u_firstname: iFirstname, u_lastname: iLastname, u_password: sha256(iPassword))
        postDecodableObject(apiroute: "/users/register", httpmethod: HTTPMethod.POST, objectToSend: registerData) { (response: User?) in
            if let response = response {
                self.actualUser = response
                print(self.actualUser!.u_email)
            } else {
                print("Katastrophe.")
            }
        } failure: { (error: String?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func getUsers() {
        fetchDecodableObject(apiroute: "/users") { (users: [User]?) in
            self.users = users
        }
    }

    func getParkingspots(){
        fetchDecodableObject(apiroute: "/parkingspots") { (parkingspots: [Parkingspot]?) in
            self.parkingspots = parkingspots
        }
    }

    
    
    /**
     * Source: https://stackoverflow.com/questions/59321972/how-to-make-a-function-that-returns-a-decodable-type-in-swift
     * `completion: @escaping (T?) -> Void` Parameter
     *      The "@escaping" part means, that this code will be run after the function is finished
     *      So when de Object is being decoded (`try JSONDecoder().decode(...)`) the completion Method
     *      will only be called, once this is finished.
     */
    func fetchDecodableObject<T: Decodable>(apiroute: String, completion: @escaping (T?) -> Void){
        guard let url = URL(string: APIURL+apiroute) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Request error: ",error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        completion(decodedObject)
                    } catch let error {
                        print("Error decoding: ", error)
                        completion(nil)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    /**
     *  Source: https://forums.swift.org/t/passing-decodable-object-type-as-generic-parameter/13870/4
     *  This Function is almost the same as the `fetchDecodableObject()` Function, but with the POST method instead of GET
     *  Here an Encodable Object is a parameter, which will be sent to the API (OBJECT converted to JSON then sent to API),
     *  then there is a Decodable Object returned, which will is being retrieved (API sends JSON which is then converted to OBJECT).
     */
    func postDecodableObject<T: Decodable, U: Encodable>(apiroute: String, httpmethod: HTTPMethod, objectToSend: U, success: @escaping (T?) -> Void, failure: @escaping (String?) -> Void){
        guard let url = URL(string: APIURL+apiroute) else {fatalError("Missing URL")}
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = httpmethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let objectToSendEncoded = try JSONEncoder().encode(objectToSend)
            urlRequest.httpBody = objectToSendEncoded
        } catch let error {
            failure("Error encoding payload: " + error.localizedDescription)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                failure("Request error: " + error.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                failure("Request error: response is not HTTPURLResponse")
                return
            }

            guard let data = data else {
                failure("Error: Cannot retrieve data")
                return
            }
            
            if [200,201].contains(response.statusCode) {
                DispatchQueue.main.async {
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        success(decodedObject)
                    } catch let error {
                        failure("Error decoding: " + error.localizedDescription)
                    }
                }
            } else {
                //  At first, the responseData needs to be converted to a JSON Array, even though there is only one Field called "message"
                //  Then there is a check, whether there was a message in the data, if true, then this message is returned
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let message = json?["message"] as? String {
                        failure("\(response.statusCode) \(message)")
                    } else {
                        failure("\(response.statusCode) Unknown")
                    }
                } catch let error {
                    failure("Error decoding: " + error.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
    
    

    /**
     *  Source: https://www.agnosticdev.com/content/how-use-commoncrypto-apis-swift-5
     *  This Method encrypts a String with SHA256
     */
    func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

