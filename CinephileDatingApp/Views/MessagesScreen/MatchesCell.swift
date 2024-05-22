//
//  MatchCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.05.2024.
//

import UIKit

class MatchesCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "matches_cell"
    
    var viewModel: MatchCellViewModel! {
        didSet {
            configureData()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.layer.borderWidth = 2
        imgV.layer.borderColor = UIColor.white.cgColor
        imgV.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        imgV.layer.cornerRadius = 40
        return imgV
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    private func configureData() {
        usernameLabel.text = viewModel.nameText
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
    }
}
