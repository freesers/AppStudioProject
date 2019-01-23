//
//  Chore.swift
//  Sweep
//
//  Created by Sander de Vries on 21/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import Foundation
import UIKit

struct Chore: Codable {
    
    var title: String
    var house: String
    var photo: UIImage
    var lastCleaned: Date?
    var cleaningDue: Date?
    var cleaningBy: String?
    
    enum CodingKeys: CodingKey {
        case title
        case house
        case photo
        case lastCleaned
        case cleaningDue
        case cleaningBy
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(house, forKey: .house)
        
        let imageData: Data = photo.jpegData(compressionQuality: 1)!
        let imageString = imageData.base64EncodedString()
        try container.encode(imageString, forKey: CodingKeys.photo)
        
        try container.encode(lastCleaned, forKey: .lastCleaned)
        try container.encode(cleaningDue, forKey: .cleaningDue)
        try container.encode(cleaningBy, forKey: .cleaningBy)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        house = try container.decode(String.self, forKey: .house)
        
        let imageString = try container.decode(String.self, forKey: .photo)
        let imageData = Data(base64Encoded: imageString)
        photo = UIImage(data: imageData!)!
        
        lastCleaned = try container.decode(Date?.self, forKey: .lastCleaned)
        cleaningDue = try container.decode(Date?.self, forKey: .cleaningDue)
        cleaningBy = try container.decode(String?.self, forKey: .cleaningBy)
    }
    
    init(title: String, house: String, image: UIImage, lastCleaned: Date?, cleaningDue: Date?, cleaningBy: String?) {
        self.title = title
        self.house = house
        self.photo = image
        self.lastCleaned = lastCleaned
        self.cleaningDue = cleaningDue
        self.cleaningBy = cleaningBy
    }
}

struct ServerChore: Codable {
    
    var id: Int
    var title: String
    var house: String
    var image: String
}
