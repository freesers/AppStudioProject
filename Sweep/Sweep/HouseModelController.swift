//
//  HouseModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 14/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

class HouseModelController {
    
    static let shared = HouseModelController()
    
    static var chores = [Chore]()

    static var houses = [House]()
    
    
//    func addHouse(with name: String, residents: [String], administrator: String ) {
//        houses.append(House(id: 0, name: name, residents: residents, administrator: administrator))
//    }
    
    static func toString(data: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: data, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    ///MARK: Servercode
    
    /// uploads new house, making the uploader the administrator
    static func uploadNewHouse(with name: String, residents: [String], administrator: String) {
        let houseURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/houses")!
        var request = URLRequest(url: houseURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let formattedName = name.replacingOccurrences(of: " ", with: "*")
        
        guard let residentsString = toString(data: residents) else { return }
        
        let postString = "name=\(formattedName)&residents=\(residentsString)&administrator=\(administrator)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (houseData, houseResponse, houseError) in
            if let houseData = houseData {
                print(houseData)
            }
        }
        task.resume()
    }
    
    /// lets new users join existing houses
    static func joinHouse(houseName: String, residentName: String) {
        getHouseID(name: houseName) { (id, residents) in
            
            // Create array from string, append new resident, transform into array again
            let residentData = residents.data(using: String.Encoding.utf8, allowLossyConversion: false)
            guard var stringArray =  try? JSONSerialization.jsonObject(with: residentData!, options: []) as! [String] else { return }
            stringArray.append(residentName)
            guard let residentsString = toString(data: stringArray) else { return }
            
            // replace existing house with updated residents
            let joinHouseURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/houses/\(id)")!
            var request = URLRequest(url: joinHouseURL)
            request.httpMethod = "PUT"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let postString = "residents=\(residentsString)"
            
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    print(data)
                }
            })
            task.resume()
        }
    }
    
    /// gets house ID and residents needed to join a new house
    static func getHouseID(name: String, completion: @escaping (Int, String) -> Void) {
        let houseNameURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/houses?name=\(name)")!
        
        let task = URLSession.shared.dataTask(with: houseNameURL) { (houseData, houseResponse, houseError) in
            if let houseData = houseData {
                guard let house = try? JSONDecoder().decode([House].self, from: houseData) else { return }
                completion(house[0].id, house[0].residents)
            } else {
                print("houseIDErro")
            }
        }
        task.resume()

    }
    
    static func loadHouses(completion: @escaping ([House]) -> Void) {
        let houseURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/houses")!
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // load existing houses in the picker view
        let task = URLSession.shared.dataTask(with: houseURL) { (houseData, houseResponse, houseError) in
            if let houseData = houseData {
                guard let serverHouses = try? JSONDecoder().decode([House].self, from: houseData) else { return }
                completion(serverHouses)
            }
        }
        task.resume()
    }
    
    /// load one house to receive all residents living in the house
    static func loadResidents(from house: String, completion: @escaping (House) -> Void) {
        let formattedHouseName = house.replacingOccurrences(of: " ", with: "*")
        
        let houseURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/houses?name=\(formattedHouseName)")!
        
        let task = URLSession.shared.dataTask(with: houseURL) { (data, response, error) in
            if let data = data {
                guard let house = try? JSONDecoder().decode([House].self, from: data) else { return }
                completion(house[0])
            }
        }
        task.resume()
    }
    
    
    
}

//let data = house[0].residents.data(using: String.Encoding.utf8, allowLossyConversion: false)
//
//if let stringArray = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String] {
//    print(stringArray)
//}


