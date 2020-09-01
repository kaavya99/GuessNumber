//
//  User.swift
//  GuessTheNumber
//
//  Created by Apurva Deshmukh on 9/1/20.
//  Copyright © 2020 Kaavya Singhal. All rights reserved.
//

struct User {
    let uid: String
    let name: String
    let email: String
    var games = [Int]()
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.games = dictionary["games"] as? [Int] ?? [Int]()
    }
}
