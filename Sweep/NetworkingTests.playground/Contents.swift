import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let image = UIImage(named: "Schermafbeelding 2019-01-16 om 17.17.56.png")
let imageData = image?.pngData()

let encodedImage = imageData?.base64EncodedString(options: .lineLength64Characters)

let decodedImageData = Data(base64Encoded: encodedImage!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
let decodedImage = UIImage(data: decodedImageData!)



func serverRequest(request:  URLRequest) {
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error)
        }
    }
    task.resume()
}


func deleteRestoServer(withId id: Int) {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/list/\(String(id))")
    var request = URLRequest(url: listUrl!)
    request.httpMethod = "DELETE"
    serverRequest(request: request)
}


struct House: Codable {
    var name: String
    
}

let house = House(name: "De Lelie")

func addTestToServer() {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/list")!
    var request = URLRequest(url: listUrl)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let postString = "De Lelie=JA&werkt=dit?&foto=\(encodedImage!)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            print(data)
        }
    }
    task.resume()
    
}

//addTestToServer()

//for i in 1...11 {
//    deleteRestoServer(withId: i)
//}


deleteRestoServer(withId: 1)
