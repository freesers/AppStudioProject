//
//  ChoreModelController.swift
//  Sweep
//
//  Created by Sander de Vries on 22/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

class ChoreModelController {
    
    static var chores = [Chore]() {
        didSet {
            uploadChore(chore: chores.last!)
        }
    }
    static var dueDate = Date()
    
    
    // get current date and next due date for chores (every sundag 23:59)
    static func setupDates() {
        DateComponents.createDates()
        DateComponents.dueDate()
        self.dueDate = DateComponents.cleaningDue
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
        if let encodedImage = imageData?.base64EncodedString(options: .lineLength76Characters) {
            return encodedImage
        } else {
            return ""
        }
    }
    
    // load chore from server 
    static func loadChores(from house: String, completion: @escaping ([ServerChore]) -> Void) {
        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
        
        let loadChoreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores?house=\(formattedHouse)")!
        
        let task = URLSession.shared.dataTask(with: loadChoreURL) { (data, response, error) in
            if let choreData = data {
                guard let chores = try? JSONDecoder().decode([ServerChore].self, from: choreData) else { return }
                completion(chores)
            }
        }
        task.resume()
    }
}
