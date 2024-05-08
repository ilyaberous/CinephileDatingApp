//
//  ProfileSettingsFooter.swift
//  CinephileDatingApp
//
//  Created by Ilya on 24.04.2024.
//

import UIKit

protocol ProfileSettingsFooterDelegate: AnyObject {
    func handleLogOut()
}

class ProfileSettingsFooter: UIView {
    // MARK: - Properties
    
    weak var delegate: ProfileSettingsFooterDelegate?
    
    private lazy var button: UIButton = {
        let btt = UIButton(type: .system)
        btt.setTitle("Выйти", for: .normal)
        btt.backgroundColor = .white
        btt.setTitleColor(.red, for: .normal)
        btt.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        return btt
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(41)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func logOutTapped() {
        delegate?.handleLogOut()
    }
    
}
