import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var currentDate = Date()
currentDate = currentDate.addingTimeInterval(60 * 60 * 24 * 7)

let userCalendar = Calendar.current

let years = 2019
let days = 27
let months = 1

var cleaningDateComponent = DateComponents()
cleaningDateComponent.year = years
cleaningDateComponent.day = days
cleaningDateComponent.month = months
cleaningDateComponent.hour = 23
cleaningDateComponent.minute = 59
cleaningDateComponent.second = 59

var weekComponent = DateComponents()
weekComponent.weekday = 1
weekComponent.hour = 23
weekComponent.minute = 59

var firstCleaningDate = userCalendar.date(from: cleaningDateComponent)!



var cleaningDates = [Date]()

for _ in 1...100 {
    let date = firstCleaningDate
    cleaningDates.append(date)
    let newDate = firstCleaningDate.addingTimeInterval(60 * 60 * 24 * 7)
    firstCleaningDate = newDate
}

var cleaningDue = Date()


for date in cleaningDates {
    if currentDate < date {
        cleaningDue = date
        break
    }
}



let dateformatter = DateFormatter()
dateformatter.locale = Locale(identifier: "nl_NL")
dateformatter.setLocalizedDateFormatFromTemplate("MMMMdE")

dateformatter.string(from: cleaningDue)
//typealias User = [UserElement]

struct User: Codable {
    let id: Int
    let uid, name, email, password: String
    let isAdministrator, house: String
}


//let image = UIImage(named: "Schermafbeelding 2019-01-16 om 17.17.56.png")
//let imageData = image?.pngData()
////print(imageData!)
//
//let encodedImage = imageData?.base64EncodedString(options: .lineLength76Characters)
////print(encodedImage!)

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
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores/\(String(id))")
    var request = URLRequest(url: listUrl!)
    request.httpMethod = "DELETE"
    serverRequest(request: request)
}



let names = ["Sander", "Wietse", "Inge"]

func json(names: [Any]) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: names, options: []) else { return nil}
    return String(data: data, encoding: .utf8)
}

let jsonNames = json(names: names)

struct House: Codable {
    
    var id: Int
    var name: String
    var residents: [String]
    var administrator: String
    
}

let house1 = House(id: 0, name: "lelie", residents: ["Sander", "West"], administrator: "Sander")

func addTestToServer() {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/list")!
    var request = URLRequest(url: listUrl)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let postString = "name=\(jsonNames!)&werkt=sadsf?&foto=hoi)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            print(data)
        }
    }
    task.resume()
    
}


//addTestToServer()

//deleteRestoServer(withId: 1)
//deleteRestoServer(withId: 2)


//typealias housje = [House]
//
//func getHouseID(name: String) {
//
//    var houseID = 0
//    let houseNameURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/houses?name=\(name)")!
//
//    let task = URLSession.shared.dataTask(with: houseNameURL) { (houseData, houseResponse, houseError) in
//        if let houseData = houseData {
//            print(houseData)
//            guard let house = try? JSONDecoder().decode(housje.self, from: houseData) else { print("huh"); return }
//            houseID = house[0].id
//            print(house[0].residents)
//
//            let data = house[0].residents.data(using: String.Encoding.utf8, allowLossyConversion: false)
//
//            if let stringArray = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String] {
//                print(stringArray)
//            }
//
//            print(houseID)
//        } else {
//            print("houseIDErro")
//        }
//    }
//    task.resume()
//}
//getHouseID(name: "Sjaakhouse")

//typealias Welcome = [WelcomeElement]

//struct WelcomeElement: Codable {
//    let id: Int
//    let name, werkt, foto: String
//}
//
//let url = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/list")
//
//let task = URLSession.shared.dataTask(with: url!) { (data, response, errro) in
//    if let data = data {
//        guard let welcome = try? JSONDecoder().decode(Welcome.self, from: data) else { return }
//        print(welcome[0].name)
//    }
//}
//task.resume()

for i in 1...20 {
    deleteRestoServer(withId: i)
}


deleteRestoServer(withId: 2)
