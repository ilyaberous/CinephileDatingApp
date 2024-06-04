//
//  FavoriteFilmsStack.swift
//  CinephileDatingApp
//
//  Created by Ilya on 03.06.2024.
//

import Foundation
import UIKit

protocol FavoriteFilmsStackDelegate: AnyObject {
    func favoriteFilmsStack(_ stack: FavoriteFilmsStack, didTapFilmCard tag: Int)
}

class FavoriteFilmsStack: UIStackView {
    
    weak var delegate: FavoriteFilmsStackDelegate?
    
    private lazy var film1: UIButton = {
        let btt = UIButton()
        btt.imageView?.contentMode = .scaleAspectFill
        btt.backgroundColor = .orange
        btt.addTarget(self, action: #selector(filmTapped(sender:)), for: .touchUpInside)
        btt.tag = 0
        return btt
    }()
    
    private lazy var film2: UIButton = {
        let btt = UIButton()
        btt.imageView?.contentMode = .scaleAspectFill
        btt.backgroundColor = .orange
        btt.addTarget(self, action: #selector(filmTapped(sender:)), for: .touchUpInside)
        btt.tag = 1
        return btt
    }()
    
    private lazy var film3: UIButton = {
        let btt = UIButton()
        btt.imageView?.contentMode = .scaleAspectFill
        btt.backgroundColor = .orange
        btt.addTarget(self, action: #selector(filmTapped(sender:)), for: .touchUpInside)
        btt.tag = 2
        return btt
    }()
    
    private lazy var film4: UIButton = {
        let btt = UIButton()
        btt.imageView?.contentMode = .scaleAspectFill
        btt.backgroundColor = .orange
        btt.addTarget(self, action: #selector(filmTapped(sender:)), for: .touchUpInside)
        btt.tag = 3
        return btt
    }()
    
    private lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [film1, film2, film3, film4])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func filmTapped(sender: UIButton) {
        delegate?.favoriteFilmsStack(self, didTapFilmCard: sender.tag)
    }
    
    func configure(with viewModel: FavoriteFilmsViewModel) {
        for button in stack.subviews {
            guard let button = button as? UIButton else {
                return
            }
            button.sd_setImage(with: URL(string: viewModel.filmsURLs[button.tag]), for: .normal)
        }
    }
}
