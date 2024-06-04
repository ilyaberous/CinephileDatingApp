//
//  FavoriteFilmsCellViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 02.06.2024.
//

import Foundation


struct FavoriteFilmsViewModel {
    let user: User
    let filmsURLs: [String]
    
    
    init(user: User) {
        self.user = user
        self.filmsURLs = user.favoriteFilmsURLs
    }
}
