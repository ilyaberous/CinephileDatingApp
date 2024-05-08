//
//  ProfileSettingCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 24.04.2024.
//

import UIKit

protocol ProfileSettingsCellDelegate: AnyObject {
    func settingsCell(_ cell: ProfileSettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSections)
    func settingsCell(_ cell: ProfileSettingsCell, wantsToUpdateAgeRangeWith sender: UISlider)
}

class ProfileSettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "setting_cell"
    
    weak var delegate: ProfileSettingsCellDelegate?
    
    var viewModel: ProfileSettingsViewModel! {
        didSet {
            configure()
        }
    }
    
    lazy var inputField: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 20)
        
        tf.placeholder = "Введите текст"
        
        let leftView = UIView()
        leftView.snp.makeConstraints { make in make.size.equalTo(CGSize(width: 16, height: 16))}
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(userInfoUpdated), for: .editingChanged)
        
        return tf
    }()
    
    let minAgeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let maxAgeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var minAgeSlider = makeAgeSlider()
    
    lazy var maxAgeSlider = makeAgeSlider()
    
    private lazy var minStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    
    private lazy var maxStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    
    private lazy var sliderStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [minStack, maxStack])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        selectionStyle = .none
        
        contentView.addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(sliderStack)
        sliderStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func makeAgeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 16
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(ageRangeChanged), for: .valueChanged)
        return slider
    }
    
    // MARK: - Helper Methods
    
    private func configure() {
        inputField.isHidden = viewModel.shouldHideInpurField
        sliderStack.isHidden = viewModel.shouldHideSlider
        
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
        
        minAgeLabel.text = viewModel.minAgeLabelText(forValue: viewModel.minAgeSliderValue)
        maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)
        
        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc private func ageRangeChanged(sender: UISlider) {
        if sender == minAgeSlider {
            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
        } else {
            maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: sender.value)
        }
        
        delegate?.settingsCell(self, wantsToUpdateAgeRangeWith: sender)
    }
    
    @objc private func userInfoUpdated(sender: UITextField) {
        print("DEBUG: Input is \(sender.text) for \(viewModel.section)")
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
}
