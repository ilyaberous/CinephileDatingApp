//
//  MatchViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 19.05.2024.
//

import Foundation


struct MatchViewModel {
    private let matchUser: User
    private let user: User
    
    let matchLabelText: String
    
    var userImageURL: URL?
    var matchedUserImageURL: URL?
    
    init(user: User, matchUser: User) {
        self.user = user
        self.matchUser = matchUser
        self.matchLabelText = "Вы и \(matchUser.name) образовали пару"
        guard let imageURLString = user.profileImageURLs.first else { return }
        self.userImageURL = URL(string: imageURLString)
        guard let matchedImageURLString = matchUser.profileImageURLs.first else { return }
        self.matchedUserImageURL = URL(string: matchedImageURLString)
    }
}
