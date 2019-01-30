//
//  ChoreScoreController.swift
//  Sweep
//
//  Created by Sander de Vries on 28/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

//import Foundation
//
//struct ChoreScoreController {
//
//    static var scores = [String: Int]()
//    static var scoreID: Int?
//
//    static func getScores(house: String) {
//        let formattedHouse = house.replacingOccurrences(of: " ", with: "*")
//
//        let scoresURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/scores?house=\(formattedHouse)")!
//
//        let task = URLSession.shared.dataTask(with: scoresURL) { (data, response, error) in
//            if let data = data {
//                let serverscores = try? JSONDecoder().decode([ServerChoreScore].self, from: data)
//                guard let dictData = serverscores?[0].scores.data(using: .utf8) else { return }
//                guard let scoresDict = try? JSONSerialization.jsonObject(with: dictData, options: []) as! [String: Int] else { return }
//                ChoreScoreController.scores = scoresDict
//                ChoreScoreController.scoreID = serverscores![0].id
//            }
//        }
//        task.resume()
//    }
//
//    static func uploadScores(with id: Int?, or house: String) {
//
//        let scoresURL = URL(string: "https://ide50-freesers.legacy.cs50.io:8080/scores/\(String(id))")!
//
//        var request = URLRequest(url: scoresURL)
//        request.httpMethod = "PUT"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        var scores = ChoreScoreController.scores
//        let user = UserModelController.currentUser.name
//        let oldScore = scores[user] ?? 0
//        scores.updateValue(oldScore + 1, forKey: user)
//        ChoreScoreController.scores = scores
//
//        guard let jsonScoreData = try? JSONSerialization.data(withJSONObject: scores, options: []) else {return}
//        let scoresString = String(data: jsonScoreData, encoding: .utf8)
//
//        let postString = "house=De*Lelie&scores=\(scoresString!)"
//        request.httpBody = postString.data(using: .utf8)
//
//    }

//    guard let scoreData = scoreData else { return }
//    let serverScores = try? JSONDecoder().decode(ServerChoreScore.self, from: scoreData)
//
//    guard let scoresDictData = serverScores?.scores.data(using: .utf8) else { return }
//    let scoresDict = try? JSONSerialization.jsonObject(with: scoresDictData, options: []) as! [String: Int]
//    print(scoresDict!)


//}
