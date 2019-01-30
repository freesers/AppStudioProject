//
//  ChoreModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 22/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Controlls the creation of chores, deletions, uploads, downloads and persistence
//  Also creates dates for chore
//

import Foundation
import UIKit


class ChoreModelController {
    
    // MARK: - Variables
    static var chores = [Chore]() 
    static var dueDate = Date()
    
    static var delegate: NewChoresDelegate?
    
    // MARK: - Dates
    
    /// gets current date and next due date for chores (every sundag 23:59)
    static func setupDates() {
        DateComponents.createDates()
        DateComponents.dueDate()
        self.dueDate = DateComponents.cleaningDue
    }
    
    /// calculates days left before deadline
    static func daysInterval(date: Date) -> Int {
        let date = Date()
        let dateInterval = date.timeIntervalSince(dueDate)
        let daysLeft = (dateInterval / (60 * 60 * 24)) * -1
        return Int(daysLeft)
    }
    
    // MARK: - Chore Network Code
    
    /// uploads chore to server
    static func uploadChore(chore: Chore) {
        
        // set properties
        let image = chore.photo
        let title = chore.title
        let house = chore.house
        let imageString = ChoreModelController.encodeImage(image: image)
        
        // create request
        let choreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores")!
        var request = URLRequest(url: choreURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // replace spaces with asterisks to work with the server
        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
        let formattedTitle = title.replacingOccurrences(of: " ", with: "*")
        
        let postString = "title=\(formattedTitle)&house=\(formattedHouse)&image=[\(imageString)]"
        request.httpBody = postString.data(using: .utf8)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // create dataTask
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /// gets chore's id number to use for modifying server data
    static func getChoreID(choreName: String, completion: @escaping (Int) -> Void) {
        let formattedChoreName = choreName.replacingOccurrences(of: " ", with: "*")
        let choreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores?title=\(formattedChoreName)")!
        
        // create dataTask
        let task = URLSession.shared.dataTask(with: choreURL) { (data, response, error) in
            if let data = data {
                guard let chores = try? JSONDecoder().decode([ServerChore].self, from: data) else { return }
                let houseName = UserModelController.currentUser.house
                let formattedHouseName = houseName.replacingOccurrences(of: " ", with: "*")
                
                // get correct chore by filtering for house
                let correctChore = chores.filter { $0.house == formattedHouseName }
                completion(correctChore[0].id)
            }
        }
        task.resume()
    }
    
    /// deletes and uploads new chore (comparing the image string gave a server error)
    static func mutateChore(chore: Chore, id: Int) {
        deleteChore(with: id) {
            uploadChore(chore: chore)
        }
    }
    
    /// deletes chore
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
    
    /// encodes image to string
    static func encodeImage(image: UIImage) -> String {
        
        // compress image for faster transmission
        let imageData = image.jpegData(compressionQuality: 0.5)
        if let encodedImage = imageData?.base64EncodedString() {
            return encodedImage
        } else {
            return ""
        }
    }
    
    /// loads chore (ServerChore) from server
    static func loadServerChores(from house: String, completion: @escaping ([ServerChore]) -> Void) {
        
        // spaces replaced with asterisks to get correct house
        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // create dataTask from URL
        let loadChoreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores?house=\(formattedHouse)")!
        let task = URLSession.shared.dataTask(with: loadChoreURL) { (data, response, error) in
            if let choreData = data {
                guard let chores = try? JSONDecoder().decode([ServerChore].self, from: choreData) else { return }
                completion(chores)
            }
        }
        task.resume()
    }
    
    /// load chores and reload cells in tableview
    static func loadChores(chores: [ServerChore]) {
        
        // loop trough all chores from serverresults
        for serverChore in chores {
            
            var imageString = serverChore.image
            
            // remove opening and closing brackets from string
            imageString.remove(at: imageString.startIndex)
            imageString.remove(at: imageString.index(before: imageString.endIndex))
            
            // format string to enable decoding ( all " "'s have to be "+"'s )
            let formattedString = imageString.replacingOccurrences(of: " ", with: "+")
            
            // decode image
            let imageData = Data(base64Encoded: formattedString)
            let image = UIImage(data: imageData!)
            
            // set Due date
            let cleaningDue = ChoreModelController.dueDate
            
            let title = serverChore.title.replacingOccurrences(of: "*", with: " ")
            
            let chore = Chore(title: title, house: serverChore.house, image: image!, lastCleaned: nil, cleaningDue: cleaningDue, cleaningBy: nil)
            ChoreModelController.chores.append(chore)
        }
        
        // reload cells
        delegate?.reloadCells()
    }
    
    // MARK: - Persistence
    
    // get URL from choresDirectory
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let choresDirectory = ChoreModelController.documentsDirectory.appendingPathComponent("Chores").appendingPathExtension("plist")
    
    /// save chores to directory
    static func saveChoresDirectory() {
        let chores: [Chore] = ChoreModelController.chores
        let plistEncoder = PropertyListEncoder()
        
        if let encodedChores = try? plistEncoder.encode(chores) {
            do {
                try encodedChores.write(to: ChoreModelController.choresDirectory, options: .noFileProtection)
                print("Saved")
            } catch {
                print("Write to choresDirectory failed")
            }
        }
    }
    
    /// loads chores from directory
    static func loadChoresDirectory(completion: @escaping () -> Void) {
        
        var loadServer = true
        
        // try loading from directory frist
        DispatchQueue.main.sync {
            let plistDecoder = PropertyListDecoder()
            if let chores = try? Data(contentsOf: ChoreModelController.choresDirectory), let decodedChores = try? plistDecoder.decode([Chore].self, from: chores) {
                ChoreModelController.chores = decodedChores
                loadServer = false
                delegate?.reloadCells()
                completion()
            }
        }
        
        // else, load from server
        if loadServer {
            ChoreModelController.loadServerChores(from: UserModelController.currentUser.house) { (chores) in
                ChoreModelController.loadChores(chores: chores)
                self.delegate?.reloadCells()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
