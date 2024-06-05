//
//  UserProfileViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 25.04.2024.
//

import Foundation
import UIKit

enum UserProfileSections: Int, CaseIterable {
    case info
    case bio
    case favoriteFilms
    
    var description: String? {
        switch self {
        case .info: return nil
        case .bio: return "О себе"
        case.favoriteFilms: return "Любимые фильмы"
        }
    }
}

struct UserProfileViewModel {
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let bio: String
    var imageURLs: [URL] {
        return user.profileImageURLs.compactMap({
            guard let url = URL(string: $0) else { return nil }
            return url
        })
    }
    
    var favoriteFilmsURLs: [URL] {
        return user.favoriteFilmsURLs.compactMap ({
            guard let url = URL(string: $0) else { return nil }
            return url
        })
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
                                                       attributes:
                                                        [.font: UIFont(name: Constants.Fonts.Montserrat.bold, size: 32) ??
                                                                .systemFont(ofSize: 32, weight: .bold)])
        attributedText.append(NSAttributedString(string: " \(user.age)",
                                                 attributes: [.font: UIFont(name: Constants.Fonts.Montserrat.medium, size: 28) ??
                                                                    .systemFont(ofSize: 28, weight: .medium)]))
        
        self.userDetailsAttributedString = attributedText
        self.bio = user.bio
    }
}
