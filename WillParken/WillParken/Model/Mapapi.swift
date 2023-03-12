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

/**
 * MAddress & MData:
 * - Are needed to decode the response from api.positionstack.com
 * - MData has the latitude and longitude of a single pin
 * - MAddress has an array of MData - because there might be more than one result in the response
 * MLocation:
 * - Stores the name and exact coordinates of a pin on the map
 */
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


struct EquatableCoordinate: Equatable {
    static func == (lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    let coordinate: CLLocationCoordinate2D
}

class Mapapi: ObservableObject{
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "92d0989cebd26dea67f59db3a280d7a6"
    
    /**
     * locations:
     * - Contains all MLocations, that will be shown on the map
     * region:
     * - Is the camera
     */
    
    @Published var region: MKCoordinateRegion
    @Published var locations: [MLocation] = []
    
    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.5162, longitude: 13.5501),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
        self.locations.insert(MLocation(name: "pin", coordinate: self.region.center), at: 0)
    }
    
    func setLocationsWithMAddressArray(arrayOfMAddress: [MAddress]) {
        if arrayOfMAddress.count == 0 { print("arrayOfMAddress is empty."); return }
        var newLocations: [MLocation] = []
        var minLat = Double.infinity
        var maxLat = -Double.infinity
        var minLon = Double.infinity
        var maxLon = -Double.infinity
        
        for address in arrayOfMAddress {
            for data in address.data {
                let newLocation = MLocation(name: data.name ?? "pin", coordinate: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude))
                newLocations.append(newLocation)
                
                minLat = min(minLat, data.latitude)
                maxLat = max(maxLat, data.latitude)
                minLon = min(minLon, data.longitude)
                maxLon = max(maxLon, data.longitude)
            }
        }
        self.locations = newLocations
        
        // Calculate a new region that encloses all the locations
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.25, longitudeDelta: (maxLon - minLon) * 1.25)
        let newRegion = MKCoordinateRegion(center: center, span: span)
        self.region = newRegion
    }
    
    func setLocationWithCoordinates(coordinates: CLLocationCoordinate2D, delta: Double){
        DispatchQueue.main.async {
            
            self.region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
            
            let newLocation = MLocation(name: "pin", coordinate: coordinates)
            
            self.locations.removeAll()
            self.locations.insert(newLocation, at: 0)
            
            print("Successfully loaded Location.")
        }
    }
    
    func setLocationWithAddress(address: String, delta: Double){
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
                
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                
                let newLocation = MLocation(name: name ?? "pin", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                
                self.locations.removeAll()
                self.locations.insert(newLocation, at: 0)
                
                print("Successfully loaded Location.")
            }
        }.resume()
    }
}
