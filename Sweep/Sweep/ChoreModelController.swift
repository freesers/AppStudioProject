//
//  ChoreModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 22/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

protocol NewChoresDelegate {
    func reloadCells()
}

class ChoreModelController {
    
    static var chores = [Chore]() 
    static var dueDate = Date()
    
    static var delegate: NewChoresDelegate?
    
    
    // get current date and next due date for chores (every sundag 23:59)
    static func setupDates() {
        DateComponents.createDates()
        DateComponents.dueDate()
        self.dueDate = DateComponents.cleaningDue
    }
    
    static func daysInterval(date: Date) -> Int {
        let date = Date()
        let dateInterval = date.timeIntervalSince(dueDate)
        
        let daysLeft = (dateInterval / (60 * 60 * 24)) * -1
        return Int(daysLeft)
        
    }
    
    /// get chore's id number to use for modifying server data
    static func getChoreID(choreName: String, completion: @escaping (Int) -> Void) {
        let formattedChoreName = choreName.replacingOccurrences(of: " ", with: "*")
        let choreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores?title=\(formattedChoreName)")!
        
        let task = URLSession.shared.dataTask(with: choreURL) { (data, response, error) in
            if let data = data {
                guard let chores = try? JSONDecoder().decode([ServerChore].self, from: data) else {print("help"); return}
                let houseName = UserModelController.currentUser.house
                let formattedHouseName = houseName.replacingOccurrences(of: " ", with: "*")
                let correctChore = chores.filter { $0.house == formattedHouseName }
                completion(correctChore[0].id)
            }
        }
        task.resume()
    }
    
    static func mutateChore(chore: Chore, id: Int) {
        deleteChore(with: id) {
            uploadChore(chore: chore)
        }
        
        
        // Will delete old and post new
        
    }
    
    static func deleteChore(with id: Int, completion: @escaping () -> Void) {
        let choreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores/\(String(id))")!
        var request = URLRequest(url: choreURL)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                completion()
            }
        }
        task.resume()
    }
    
    
    
    // upload chore to server
    static func uploadChore(chore: Chore) {
        let image = chore.photo
        let title = chore.title
        let house = chore.house
        let imageString = ChoreModelController.encodeImage(image: image)
        
        let choreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores")!
        var request = URLRequest(url: choreURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
        
        let postString = "title=\(title)&house=\(formattedHouse)&image=[\(imageString)]"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    
    // encode image to string
    static func encodeImage(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.5)
        if let encodedImage = imageData?.base64EncodedString() {
            return encodedImage
        } else {
            return ""
        }
    }
    
    // load chore from server 
    static func loadServerChores(from house: String, completion: @escaping ([ServerChore]) -> Void) {
        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
        
        let loadChoreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores?house=\(formattedHouse)")!
        
        let task = URLSession.shared.dataTask(with: loadChoreURL) { (data, response, error) in
            if let choreData = data {
                guard let chores = try? JSONDecoder().decode([ServerChore].self, from: choreData) else { return }
                completion(chores)
            }
        }
        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    static func loadChores(chores: [ServerChore]) {
        
        // loop trough all chores from serverresults
        for serverChore in chores {
            var imageString = serverChore.image
            
            // format string to enable decoding ( all " "'s have to be "+"'s )
            imageString.remove(at: imageString.startIndex)
            imageString.remove(at: imageString.index(before: imageString.endIndex))
            let formattedString = imageString.replacingOccurrences(of: " ", with: "+")

            let imageData = Data(base64Encoded: formattedString)
            let image = UIImage(data: imageData!)
            let cleaningDue = ChoreModelController.dueDate
            
            let chore = Chore(title: serverChore.title, house: serverChore.house, image: image!, lastCleaned: nil, cleaningDue: cleaningDue, cleaningBy: nil)
            
            ChoreModelController.chores.append(chore)
        }
    }
    
    //MARK: Persistence
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let choresDirectory = ChoreModelController.documentsDirectory.appendingPathComponent("Chores").appendingPathExtension("plist")
    
    static func saveChoresDirectory() {
        let chores: [Chore] = ChoreModelController.chores
        let plistEncoder = PropertyListEncoder()
        
        if let encodedChores = try? plistEncoder.encode(chores) {
            do {
                try encodedChores.write(to: ChoreModelController.choresDirectory, options: .noFileProtection)
            } catch {
                print("Write to choresDirectory failed")
            }
        }
    }
    
    static func loadChoresDirectory(completion: @escaping () -> Void) {
        let plistDecoder = PropertyListDecoder()
        if let chores = try? Data(contentsOf: ChoreModelController.choresDirectory), let decodedChores = try? plistDecoder.decode([Chore].self, from: chores) {
            ChoreModelController.chores = decodedChores
            completion()
        } else {
            ChoreModelController.loadServerChores(from: UserModelController.currentUser.house) { (chores) in
                ChoreModelController.loadChores(chores: chores)
                self.delegate?.reloadCells()
            }
        }
    }

    
    
}
