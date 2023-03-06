//
//  WPapi.swift
//  WillParken
//
//  Created by Arbi Said on 21.01.23.
//
//
//  https://designcode.io/swiftui-advanced-handbook-http-request
//  https://medium.com/@nutanbhogendrasharma/consume-rest-api-in-swiftui-ios-mobile-app-b3c5d6ecf401

import Foundation
import CommonCrypto

class WPapi: ObservableObject{
    
    //  MARK: - URL -
    private final var APIURL: String = "http://192.168.0.7:3000"
    
    //  MARK: - API -
    struct APIResponseWrapper<T: Decodable>: Decodable {
        let message: String
        let content: T
    }
    
    /**
     * Source: https://stackoverflow.com/questions/59321972/how-to-make-a-function-that-returns-a-decodable-type-in-swift
     * `completion: @escaping (T?) -> Void` Parameter
     *      The "@escaping" part means, that this code will be run after the function is finished
     *      So when de Object is being decoded (`try JSONDecoder().decode(...)`) the completion Method
     *      will only be called, once this is finished.
     */
    func fetchDecodableObject<T: Decodable>(apiroute: String, success: @escaping (T?) -> Void){
        guard let url = URL(string: APIURL+apiroute) else {fatalError("Missing URL")}
        var urlRequest = URLRequest(url: url)
        
        let sessionID = UserDefaults.standard.string(forKey: "cookie")
        if let sessionID = sessionID {
            urlRequest.setValue(sessionID, forHTTPHeaderField: "Cookie")
//            print("GET BEF REQUEST: \(sessionID)")
        }

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Request error: ",error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            
            if let setCookieHeader = response.allHeaderFields["Set-Cookie"] as? String {
                    UserDefaults.standard.set(setCookieHeader, forKey: "cookie")
//                print("GET AFT REQUEST: \(setCookieHeader)")
            }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedWrapper = try JSONDecoder().decode(APIResponseWrapper<T>.self, from: data)
                        let decodedObject = decodedWrapper.content
                        success(decodedObject)
                    } catch let error {
                        print("Error decoding: ", error)
                        success(nil)
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

        //  Retrieve the session ID from UserDefaults
        let sessionID = UserDefaults.standard.string(forKey: "cookie")
        if let sessionID = sessionID {
            urlRequest.setValue(sessionID, forHTTPHeaderField: "Cookie")
//            print("POST BEF REQUEST: \(sessionID)")
        }

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
                //  Extract the session ID from the response headers and store it in UserDefaults
                if let setCookieHeader = response.allHeaderFields["Set-Cookie"] as? String {
                    UserDefaults.standard.set(setCookieHeader, forKey: "cookie")
//                    print("POST AFT REQUEST: \(setCookieHeader)")
                }

                DispatchQueue.main.async {
                    do {
                        let decodedWrapper = try JSONDecoder().decode(APIResponseWrapper<T>.self, from: data)
                        let decodedObject = decodedWrapper.content
                        success(decodedObject)
                    } catch let error {
                        failure("Error decoding: (probably wrong format) " + error.localizedDescription)
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

