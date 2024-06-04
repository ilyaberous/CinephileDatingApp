//
//  FavoriteFilmsCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 22.05.2024.
//

import UIKit

protocol FavoriteFilmsCellDelegate: AnyObject {
    func favoriteFilmCell(_ cell: FavoriteFilmsCell, wantsToPresentSearchViewControllerForFilmCardWith tag: Int)
}

class FavoriteFilmsCell: UITableViewCell {
    
    static let identifier = "favotire_films_cell"
    var viewModel: FavoriteFilmsViewModel! {
        didSet {
            filmCardsStack.configure(with: viewModel)
        }
    }
    weak var delegate: FavoriteFilmsCellDelegate?
    
    private lazy var filmCardsStack: FavoriteFilmsStack = {
        let stack = FavoriteFilmsStack()
        stack.delegate = self
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = .systemGroupedBackground
        contentView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(filmCardsStack)
        filmCardsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        print("DEBUG: FavoritefilmsCell init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FavoriteFilmsStack Delegate Methods

extension FavoriteFilmsCell: FavoriteFilmsStackDelegate {
    func favoriteFilmsStack(_ stack: FavoriteFilmsStack, didTapFilmCard tag: Int) {
        delegate?.favoriteFilmCell(self, wantsToPresentSearchViewControllerForFilmCardWith: tag)
    }
}
