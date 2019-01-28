import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var cleaningDayComponent = DateComponents(calendar: nil, timeZone: nil, era: nil, year: 2019, month: 1, day: 27, hour: 23, minute: 59, second: 59, nanosecond: nil, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)

var firstCleaningDate = Calendar.current.date(from: cleaningDayComponent)
var calendar = Calendar.current
calendar.firstWeekday = 2
let week = calendar.component(.weekOfMonth, from: firstCleaningDate!)


var datenew = Date().addingTimeInterval(60*60*24*5*7)
var calendar2 = Calendar.current
calendar2.firstWeekday = 2
let currentweek = calendar2.component(.weekOfYear, from: datenew)
//var date = Date()
//let calendar = Calendar.current
//
//var week = calendar.component(.weekOfYear, from: date)
//
//calendar
//let nextweek = calendar.date(byAdding: .day, value: 7, to: date)
//let weekday = calendar.component(.weekOfYear, from: nextweek!)


struct ServerChore: Codable {
    
    var id: Int
    var title: String
    var house: String
    var image: String
}


func loadServerChores(from house: String, completion: @escaping ([ServerChore]) -> Void) {
    let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
    print("1")
    let loadChoreURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores?house=\(formattedHouse)")!
    print("2")
    let task = URLSession.shared.dataTask(with: loadChoreURL) { (data, response, error) in
        if let choreData = data {
            guard let chores = try? JSONDecoder().decode([ServerChore].self, from: choreData) else {
                print("fail")
                return  }
            completion(chores)
            print("complete")
        }
    }
    task.resume()
}

let a = [1,2,3]
let b = a.filter { $0 != 2 }
b

//loadServerChores(from: "De Lelie") { (serverchore) in
//    let imageString = serverchore[0].image
//    print(imageString)
//    let imageData = Data(base64Encoded: imageString)
//    print(imageData as Any)
//    let image = UIImage(data: imageData!)
//    print(image!)
//}


let deleteURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/users/12")!
var request = URLRequest(url: deleteURL)
request.httpMethod = "DELETE"
URLSession.shared.dataTask(with: request).resume()

//var currentDate = Date()
//currentDate = currentDate.addingTimeInterval(60 * 60 * 24 * 7)
//
//let userCalendar = Calendar.current
//
//let years = 2019
//let days = 27
//let months = 1
//
//var cleaningDateComponent = DateComponents()
//cleaningDateComponent.year = years
//cleaningDateComponent.day = days
//cleaningDateComponent.month = months
//cleaningDateComponent.hour = 23
//cleaningDateComponent.minute = 59
//cleaningDateComponent.second = 59
//
//var weekComponent = DateComponents()
//weekComponent.weekday = 1
//weekComponent.hour = 23
//weekComponent.minute = 59
//
//var firstCleaningDate = userCalendar.date(from: cleaningDateComponent)!
//
//
//
//var cleaningDates = [Date]()
//
//for _ in 1...100 {
//    let date = firstCleaningDate
//    cleaningDates.append(date)
//    let newDate = firstCleaningDate.addingTimeInterval(60 * 60 * 24 * 7)
//    firstCleaningDate = newDate
//}
//
//var cleaningDue = Date()
//
//
//for date in cleaningDates {
//    if currentDate < date {
//        cleaningDue = date
//        break
//    }
//}
//
//
//
//let dateformatter = DateFormatter()
//dateformatter.locale = Locale(identifier: "nl_NL")
//dateformatter.setLocalizedDateFormatFromTemplate("MMMMdE")
//
//dateformatter.string(from: cleaningDue)
////typealias User = [UserElement]
//
struct User: Codable {
    let id: Int
    let uid, name, email, password: String
    let isAdministrator, house: String
}


//let image = UIImage(named: "Schermafbeelding 2019-01-16 om 17.17.56.png")
//let imageData = image?.jpegData(compressionQuality: 1)
////print(imageData!)
//
//let encodedImage = imageData?.base64EncodedString(options: .lineLength76Characters)
////print(encodedImage!)
//
//let decodedImageData = Data(base64Encoded: encodedImage!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
//let decodedImage = UIImage(data: decodedImageData!)
//
//
//
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

////serverRequest()
//
func deleteRestoServer(withId id: Int) {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/chores/\(String(id))")
    var request = URLRequest(url: listUrl!)
    request.httpMethod = "DELETE"
    serverRequest(request: request)
}
//
//
//
//let names = ["Sander", "Wietse", "Inge"]
//
//func json(names: [Any]) -> String? {
//    guard let data = try? JSONSerialization.data(withJSONObject: names, options: []) else { return nil}
//    return String(data: data, encoding: .utf8)
//}
//
//let jsonNames = json(names: names)
//
//struct House: Codable {
//
//    var id: Int
//    var name: String
//    var residents: [String]
//    var administrator: String
//
//}
//
//let house1 = House(id: 0, name: "lelie", residents: ["Sander", "West"], administrator: "Sander")
//

typealias List = [ListElement]

struct ListElement: Codable {
    
    var id: String
    var name: String

}

func addTestToServer() {
    let listUrl = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/scores")!
    var request = URLRequest(url: listUrl)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let scores = ["Sander": 5, "Ali": 10]
    guard let jsonScoreData = try? JSONSerialization.data(withJSONObject: scores, options: []) else {return}
    let scoresString = String(data: jsonScoreData, encoding: .utf8)
    
    
    
    
    let postString = "house=De*Lelie&scores=\(scoresString!)"
    request.httpBody = postString.data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            print(data)
            guard let listID = try? JSONDecoder().decode(List.self, from: data) else { print("why");return }
            print(listID[0])
        }
        if let response = response {
            print(response.description)
        }
        
    }
    task.resume()

}


addTestToServer()

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

//for i in 1...20 {
//    deleteRestoServer(withId: i)
//}
//
//
//deleteRestoServer(withId: 8)
