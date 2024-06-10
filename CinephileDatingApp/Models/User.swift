//
//  User.swift
//  CinephileDatingApp
//
//  Created by Ilya on 15.04.2024.
//

import Foundation
import UIKit

struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var profileImageURLs: [String]
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var bio: String
    var favoriteFilmsURLs: [String]
    var favoriteFilmsImagesURLs: [String]
    
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.age = dict["age"] as? Int ?? 0
        self.email = dict["email"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
        self.profileImageURLs = dict["imageURLs"] as? [String] ?? [String]()
        self.minSeekingAge = dict["minSeekingAge"] as? Int ?? 16
        self.maxSeekingAge = dict["maxSeekingAge"] as? Int ?? 60
        self.bio = dict["bio"] as? String ?? ""
        self.favoriteFilmsURLs = dict["favoriteFilmsURLs"] as? [String] ?? [String]()
        self.favoriteFilmsImagesURLs = dict["favoriteFilmsImagesURLs"] as? [String] ?? [String]()
    }
}
