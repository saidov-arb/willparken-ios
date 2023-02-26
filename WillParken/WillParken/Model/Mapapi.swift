//
//  MapAPI.swift
//  WillParken
//
//  Created by Arbi Said on 26.02.23.
//
//  https://www.youtube.com/watch?v=dJ6f2o92tKg
//  https://positionstack.com

import Foundation
import MapKit

struct MAddress: Codable {
    let data: [MData]
}

struct MData: Codable {
    let latitude, longitude: Double
    let name: String?
}

struct MLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class Mapapi: ObservableObject{
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "92d0989cebd26dea67f59db3a280d7a6"
    
    @Published var region: MKCoordinateRegion
//    @Published var coordinates = []
    @Published var locations: [MLocation] = []
    
    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.5162, longitude: 13.5501),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
        self.locations.insert(MLocation(name: "pin", coordinate: self.region.center), at: 0)
    }
    
    func updateLocation(address: String, delta: Double){
        let paddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(paddress)"
        
        guard let url = URL(string: url_string) else {
            print("Invalid URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(MAddress.self, from: data) else {
                return
            }
            if newCoordinates.data.isEmpty {
                print("Could not find the address...")
                return
            }
            
            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                
//                self.coordinates = [lat,lon]
                
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                
                let newLocation = MLocation(name: name ?? "pin", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                
                self.locations.removeAll()
                self.locations.insert(newLocation, at: 0)
                
                print("Successfully loaded Location.")
            }
        }.resume()
    }
}
