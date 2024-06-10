//
//  UserProfileInfoTableCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 05.06.2024.
//

import UIKit

class UserProfileInfoTableCell: UITableViewCell {
    static let identifier = "info_cell"
    
    var viewModel: UserProfileViewModel! {
        didSet {
            configure()
        }
    }
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
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
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
    }
    
    private func configure() {
        infoLabel.attributedText = viewModel.userDetailsAttributedString
    }
}
