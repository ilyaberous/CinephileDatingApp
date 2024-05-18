//
//  UserProfileViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 25.04.2024.
//

import Foundation
import UIKit


struct UserProfileViewModel {
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let bio: String
    var imageURLs: [URL] {
        return user.profileImageURLs.map({ URL(string: $0)! })
    }
    var imageCountForProgressBar: Int {
        return user.profileImageURLs.count != 1 ? user.profileImageURLs.count : 0
    }
    
    var imageCount: Int {
        return user.profileImageURLs.count
    }
    
    init(user: User) {
        self.user = user
        let attributedText = NSMutableAttributedString(string: user.name,
                                                                     attributes: [.font: UIFont(name: Constants.Fonts.Montserrat.bold, size: 32)])
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont(name: Constants.Fonts.Montserrat.medium, size: 28)]))
        
        self.userDetailsAttributedString = attributedText
        self.bio = user.bio
    }
}
