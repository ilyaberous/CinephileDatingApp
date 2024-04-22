//
//  HomeVerticalStackView.swift
//  CinephileDatingApp
//
//  Created by Default on 09.04.2024.
//

import UIKit

class HomeVerticalStackView: UIStackView {
    //MARK: - Properties
    
    var superView: UIView!
    lazy var topStack = HomeNavigationStackView(frame: .zero, superview: self.superView)
    lazy var bottomStack = HomeActionsStackView(frame: .zero, superview: self.superView)
    let cardTemplateView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 8
        return view
    }()
    let card1 = CardView(viewModel: CardViewModel(user: User(name: "Анастасия Романова", age: 20, images: [#imageLiteral(resourceName: "jane3"), #imageLiteral(resourceName: "jane1"), #imageLiteral(resourceName: "jane2")])))
    let card2 = CardView(viewModel: CardViewModel(user: User(name: "Катя Шутова", age: 20, images: [#imageLiteral(resourceName: "kelly3"), #imageLiteral(resourceName: "kelly1")])))
    
    //MARK: - Lifecycle
    
    init(frame: CGRect, superview: UIView) {
        super.init(frame: frame)
        
        self.superView = superview
        superView.addSubview(self)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        [topStack, cardTemplateView, bottomStack].forEach { el in
            addArrangedSubview(el)
        }
        
        [card1, card2].forEach { card in
            cardTemplateView.addSubview(card)
        }
        
        
        axis = .vertical
        distribution = .equalSpacing
        
        setupConstraints()
        
        bringSubviewToFront(cardTemplateView)
    }
    
    private func setupConstraints() {
        cardTemplateView.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom)//.offset(12)
        }
        
        bottomStack.snp.makeConstraints { make in
            make.top.equalTo(cardTemplateView.snp.bottom)//.offset(12)
        }
        
        self.snp.makeConstraints { make in
            make.edges.equalTo(self.superView.safeAreaLayoutGuide).inset(16)
        }
        
        [card1, card2].forEach { card in
            card.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
