//
//  AuthViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 22.04.2024.
//

import Foundation
import UIKit

// MARK: - Protocol for Login and Register ViewModel delegates

protocol AuthenticationDelegate: AnyObject {
    func switchButtonToEnabledMode()
    func switchButtonToDisenabledMode()
}

//MARK: - Protocol for Login and Register ViewModels

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

class LoginViewModel: AuthenticationViewModel {
    
    weak var delegate: AuthenticationDelegate?
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    func isButtonEnabledOrDisenabled() {
        if self.formIsValid {
            delegate?.switchButtonToEnabledMode()
        } else {
            delegate?.switchButtonToDisenabledMode()
        }
    }
}

class RegisterViewModel: AuthenticationViewModel {
    
    weak var delegate: AuthenticationDelegate?
    var name: String?
    var email: String?
    var password: String?
    var img: UIImage?
    
    var formIsValid: Bool {
        return name?.isEmpty == false &&
               email?.isEmpty == false &&
               password?.isEmpty == false &&
               img != UIImage(named: "avatar_form")?.withRenderingMode(.alwaysOriginal) &&
               img != nil
    }
    
    func isButtonEnabledOrDisenabled() {
        if self.formIsValid {
            delegate?.switchButtonToEnabledMode()
        } else {
            delegate?.switchButtonToDisenabledMode()
        }
    }
}
