//
//  NameAgeCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 22.05.2024.
//

import UIKit

protocol ProfileSettingsCellDelegate: AnyObject {
    func settingsCell(_ cell: UITableViewCell, wantsToUpdateUserWith value: String, for section: SettingsSections)
    func settingsCell(_ cell: UITableViewCell, wantsToUpdateAgeRangeWith sender: UISlider)
}

class NameAgeCell: UITableViewCell {
    
    static let identifier = "name_age_cell"
    
    weak var delegate: ProfileSettingsCellDelegate?
    
    var viewModel: ProfileSettingsViewModel! {
        didSet {
            configure()
        }
    }
    
    lazy var inputField: UITextField = {
       var tf = UITextField()
        //tf = UITextField.textFieldWithInsets(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 20)
        
        let leftView = UIView()
        leftView.snp.makeConstraints { make in make.size.equalTo(CGSize(width: 16, height: 16))}
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(userInfoUpdated), for: .editingChanged)
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGroupedBackground
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        print("DEBUG: cell height: \(frame.height)")
        
        selectionStyle = .none
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        contentView.addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func configure() {
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
    }
    
    // MARK: - Selectors
    
    @objc private func userInfoUpdated(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
}
