//
//  CustomTextField.swift
//  CinephileDatingApp
//
//  Created by Ilya on 16.04.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, shouldSecurity: Bool = false, shouldEmailKeyboard: Bool = false) {
        super.init(frame: .zero)

        self.placeholder = placeholder
        
        self.snp.makeConstraints{ make in make.height.equalTo(40) }
        
        let spacer = UIView()
        spacer.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(12)
        }
        leftView = spacer
        leftViewMode = .always
        
        autocorrectionType = .no
        autocapitalizationType = .none
        returnKeyType = .continue
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .white
        clearsOnBeginEditing = false
        
        if shouldSecurity {
            isSecureTextEntry = true

            let eyeButton = makeEyeButtonRightView()
            rightView = eyeButton
            rightViewMode = .always
        }
        
        if shouldEmailKeyboard { keyboardType = .emailAddress }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI Element Method
    
    private func makeEyeButtonRightView() -> UIView {
        let eyeButton = UIButton(type: .system)
        eyeButton.tintColor = .lightGray
        
        let eyeIcon = UIImage(named: "eye_closed")?.withRenderingMode(.alwaysTemplate)
        eyeButton.setImage(eyeIcon, for: .normal)
        eyeButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        
        eyeButton.addTarget(self, action: #selector(tappedEyeButton), for: .touchUpInside)
        
        let view = UIView()
        view.contentMode = .center
        view.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        view.addSubview(eyeButton)
        view.isUserInteractionEnabled = true
        eyeButton.snp.makeConstraints { make in make.center.equalToSuperview() }
        return view
    }
    
    
    //MARK: - Selectors
    
    @objc private func tappedEyeButton(sender: UIButton) {
        print("Hello world!!")
        if sender.image(for: .normal)?.pngData() == UIImage(named: "eye_open")?.pngData() {
            sender.setImage(UIImage(named: "eye_closed"), for: .normal)
            isSecureTextEntry = true
        } else {
            sender.setImage(UIImage(named: "eye_open"), for: .normal)
            isSecureTextEntry = false
        }
    }
}
