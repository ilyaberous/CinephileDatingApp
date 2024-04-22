//
//  RegisterViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 16.04.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel = RegisterViewModel()
    let nameTextField = CustomTextField(placeholder: "Имя")
    let emailTextField = CustomTextField(placeholder: "Адрес электронной почты", shouldEmailKeyboard: true)
    let passwordTextField = CustomTextField(placeholder: "Пароль", shouldSecurity: true)
    let button = LogRegButton(label: "Зарагестрироваться")
    lazy var profileAvatar: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "avatar_form")?.withRenderingMode(.alwaysOriginal))
        imgV.contentMode = .scaleAspectFill
        imgV.layer.masksToBounds = true
        imgV.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        imgV.addGestureRecognizer(gesture)
        
        return imgV
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        setupUI()
        setupDelegates()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [nameTextField, emailTextField, passwordTextField, button, profileAvatar].forEach { view in self.view.addSubview(view) }
        
        profileAvatar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileAvatar.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
        }
    }
    
    //MARK: - Helper Methods
    
    private func setupDelegates() {
        viewModel.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Selectors
    
    @objc private func avatarTapped(sender: UIImageView) {
        showPhotoActionSheet()
    }
}

//MARK: - UITextField Delegate Methods

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            return true
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.name = nameTextField.text
        } else if textField == emailTextField {
            viewModel.email = emailTextField.text
        } else if textField == passwordTextField {
            viewModel.password = passwordTextField.text
        }
        
        print(viewModel.img == UIImage(named: "avatar_form")?.withRenderingMode(.alwaysOriginal))
        viewModel.isButtonEnabledOrDisenabled()
    }
}

//MARK: - Register ViewModel Delegate Methods

extension RegisterViewController: AuthenticationDelegate {
    func switchButtonToEnabledMode() {
        button.switchToEnabledState()
    }
    
    func switchButtonToDisenabledMode() {
        button.switchToDisenabledState()
    }
}

//MARK: - UIImagePickerController Deelegate Methods

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Avatar",
                                            message: "How would you like to select a photo",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Choose photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.showPhotoPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.showCamera()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func showCamera() {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.allowsEditing = true
        camera.sourceType = .camera
        present(camera, animated: true)
    }
    
    func showPhotoPicker() {
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        present(photoPicker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.profileAvatar.layer.cornerRadius = self.profileAvatar.frame.height / 2
        self.profileAvatar.image = image
        viewModel.img = self.profileAvatar.image
        viewModel.isButtonEnabledOrDisenabled()
    }
    
}

