//
//  UserProfileBioTableCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 05.06.2024.
//

import UIKit

class UserProfileBioTableCell: UITableViewCell {
    
    static let identifier = "bio_cell"
    
    var viewModel: UserProfileViewModel! {
        didSet {
            configure()
        }
    }
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 18)
        return label
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
        addSubview(bioLabel)
        bioLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func configure() {
        bioLabel.text = viewModel.bio
    }
}
