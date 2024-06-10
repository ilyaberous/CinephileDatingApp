//
//  UserProfileFavoriteFilmsTableCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 05.06.2024.
//

import UIKit

protocol UserProfileFavoriteFilmsCellDelegate: AnyObject {
    func favoriteFilmCell(_ cell: UserProfileFavoriteFilmsTableCell, wantsToPresentFilmPageViewControllerForFilmCardWith tag: Int)
}

class UserProfileFavoriteFilmsTableCell: UITableViewCell {
    static let identifier = "favorite_films_cell"
    
    weak var delegate: UserProfileFavoriteFilmsCellDelegate?
    
    var viewModel: UserProfileViewModel! {
        didSet {
            configure()
        }
    }

    lazy private var films: FavoriteFilmsStack = {
       let films = FavoriteFilmsStack()
        films.delegate = self
        return films
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: UserProfileInfoTableCell.identifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(films)
        films.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func configure() {
        films.configure(with: viewModel)
    }
}

// MARK: - FavoriteFilmsStack Delegate Methods

extension UserProfileFavoriteFilmsTableCell: FavoriteFilmsStackDelegate {
    func favoriteFilmsStack(_ stack: FavoriteFilmsStack, didTapFilmCard tag: Int) {
        delegate?.favoriteFilmCell(self, wantsToPresentFilmPageViewControllerForFilmCardWith: tag)
        print("DEBUG: film page present!!")
    }
}
