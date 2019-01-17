import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//typealias User = [UserElement]

struct User: Codable {
    let id: Int
    let uid, name, email, password: String
    let isAdministrator, house: String
}


let image = UIImage(named: "Schermafbeelding 2019-01-16 om 17.17.56.png")
let imageData = image?.pngData()
//print(imageData!)

let encodedImage = imageData?.base64EncodedString(options: .lineLength76Characters)
//print(encodedImage!)

//let decodedImageData = Data(base64Encoded: encodedImage!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//let decodedImage = UIImage(data: decodedImageData!)



func serverRequest(request: URLRequest) {
    
    
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error)
        }
        if let data = data {
            print(data)
            let decoder = JSONDecoder()
            let user = try? decoder.decode([User].self, from: data)
            if let user = user {
                print(user)
            }
        }
    }
    task.resume()
}

//serverRequest()

func deleteRestoServer(withId id: Int) {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/users/\(String(id))")
    var request = URLRequest(url: listUrl!)
    request.httpMethod = "DELETE"
    serverRequest(request: request)
}


struct House: Codable {
    var name: String
    
}

func addTestToServer() {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/list")!
    var request = URLRequest(url: listUrl)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let postString = "name=JasA&werkt=sadsf?&foto=hoi)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            print(data)
        }
    }
    task.resume()
    
}


//addTestToServer()

for i in 1...20 {
    deleteRestoServer(withId: i)
}


//deleteRestoServer(withId: 1)
