//
//  LoginViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 19.04.2024.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Properties
    
    let viewModel: LoginViewModel = LoginViewModel()
    let emailTextField = CustomTextField(placeholder: "Адрес электронной почты", shouldEmailKeyboard: true)
    let passwordTextField = CustomTextField(placeholder: "Пароль", shouldSecurity: true)
    let button = LogRegButton(label: "Продолжить")
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        title = "Вход"
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        [emailTextField, passwordTextField, button].forEach { view in self.view.addSubview(view) }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.right.equalToSuperview().inset(16)
        }
    
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).inset(-14)
        }

        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
        }
    }
    
    //MARK: - Helper Methods
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        viewModel.delegate = self
    }
}

//MARK: - UITextField Delegate Methods

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            return true
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.email = emailTextField.text
        } else {
            viewModel.password = passwordTextField.text
        }
        
        viewModel.isButtonEnabledOrDisenabled()
        print("did change \(String(describing: textField.text))")
    }
}

//MARK: - LoginViewModel Delegate Methods

extension LoginViewController: AuthenticationDelegate {
    func switchButtonToEnabledMode() {
        button.switchToEnabledState()
    }
    
    func switchButtonToDisenabledMode() {
        button.switchToDisenabledState()
    }
}

