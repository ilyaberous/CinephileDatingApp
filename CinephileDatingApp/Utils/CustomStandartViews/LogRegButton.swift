//
//  LogRegButton.swift
//  CinephileDatingApp
//
//  Created by Ilya on 17.04.2024.
//

import UIKit

class LogRegButton: UIButton {
    init(label: String) {
        super.init(frame: .zero)
        
        let font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        let attributedTitle = NSAttributedString(string: label, attributes: [.font: font])
        setAttributedTitle(attributedTitle, for: .normal)
        switchToDisenabledState()
        
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 8
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    
    func switchToEnabledState() {
            isEnabled = true
            backgroundColor = Constants.Colors.customBlack
    }
    
    func switchToDisenabledState() {
            isEnabled = false
            backgroundColor = .darkGray
    }
    
}
