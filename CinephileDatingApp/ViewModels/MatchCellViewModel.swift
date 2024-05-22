//
//  MatchCellViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.05.2024.
//

import Foundation


struct MatchCellViewModel {
    let nameText: String
    var profileImageURL: URL?
    let uid: String
    
    init(match: Match) {
        self.nameText = match.name
        self.profileImageURL = URL(string: match.profileImageURL)
        self.uid = match.uid
    }
}
