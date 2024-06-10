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
    let filmsImagesURLs: [String]
    
    
    init(user: User) {
        self.user = user
        self.filmsURLs = user.favoriteFilmsURLs
        self.filmsImagesURLs = user.favoriteFilmsImagesURLs
    }
}
