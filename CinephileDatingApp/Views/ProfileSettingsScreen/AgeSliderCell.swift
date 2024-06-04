//
//  AgeSliderCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 22.05.2024.
//

import UIKit

class AgeSliderCell: UITableViewCell {
    
    static let identifier = "age_slider_cell"
    
    weak var delegate: ProfileSettingsCellDelegate?
    
    var viewModel: ProfileSettingsViewModel! {
        didSet {
            configure()
        }
    }
    
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
        backgroundColor = .systemGroupedBackground
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
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
}
