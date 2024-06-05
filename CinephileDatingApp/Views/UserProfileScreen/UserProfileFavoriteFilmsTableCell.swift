//
//  UserProfileFavoriteFilmsTableCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 05.06.2024.
//

import UIKit

class UserProfileFavoriteFilmsTableCell: UITableViewCell {
    static let identifier = "favorite_films_cell"
    
    var viewModel: UserProfileViewModel! {
        didSet {
            configure()
        }
    }
    
   
    private let films = FavoriteFilmsStack()
    
    init() {
        super.init(style: .default, reuseIdentifier: UserProfileInfoTableCell.identifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(films)
        films.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func configure() {
        films.configure(with: viewModel.favoriteFilmsURLs)
    }
}
