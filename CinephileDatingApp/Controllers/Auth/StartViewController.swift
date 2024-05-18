//
//  LoginViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 16.04.2024.
//

import UIKit

protocol LoginRegisterDelegate: AnyObject {
    func switchAppToNewUser()
}

class StartViewController: UIViewController {

    //MARK: - Properties
    
    weak var delegate: LoginRegisterDelegate?
    private lazy var button: UIButton = {
        let btt = LogRegButton(label: "Войти с эл. почтой")
        btt.switchToEnabledState()
        btt.addTarget(self, action: #selector(presentModal), for: .touchUpInside)
        return btt
    }()
    
    private let bottomWhiteView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private let appInfoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        let titleFont = UIFont(name: Constants.Fonts.Montserrat.bold, size: 60) ?? UIFont.systemFont(ofSize: 60, weight: .medium)
        let descFont = UIFont(name: Constants.Fonts.Montserrat.bold, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        print(Constants.Fonts.Montserrat.medium)
        let attributedText = NSMutableAttributedString(string: "OBSCURA", attributes: [.font: titleFont])
        attributedText.append(NSAttributedString(string: "\nЗНАКОМСТВА \nДЛЯ \nКИНОМАНОВ", attributes: [.font: descFont]))
        label.attributedText = attributedText
        label.textColor = .white
        return label
    }()
    
    private lazy var img: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "tarkovski")?.withRenderingMode(.alwaysOriginal))
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5, 1]
        gradient.frame = imgV.frame
        imgV.layer.addSublayer(gradient)
        return imgV
    }()
    
    private var filmImageWithDesc = FilmShotImageWithDescriptionView(title: "ИВАНОВО ДЕТСТВО", director: "АНДРЕЙ ТАРКОВСКИЙ", year: 1963, image: UIImage(named: "tarkovski")!)
    
    private let loginBttStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        let google: UIButton = {
            let btt = UIButton(type: .system)
            btt.frame.size = CGSize(width: 36, height: 36)
            btt.setImage(UIImage(named: "google_btt")?.withRenderingMode(.alwaysOriginal), for: .normal)
            btt.clipsToBounds = true
           return btt
        }()
        
        let apple: UIButton = {
            let btt = UIButton(type: .system)
             btt.frame.size = CGSize(width: 36, height: 36)
            btt.setImage(UIImage(named: "apple_btt")?.withRenderingMode(.alwaysOriginal), for: .normal)
             btt.clipsToBounds = true
            return btt
         }()
        
        let phone: UIButton = {
            let btt = UIButton(type: .system)
             btt.frame.size = CGSize(width: 36, height: 36)
            btt.setImage(UIImage(named: "phone_btt")?.withRenderingMode(.alwaysOriginal), for: .normal)
             btt.clipsToBounds = true
            return btt
         }()
        
        [google, apple, phone].forEach { btt in stack.addArrangedSubview(btt) }
        
        return stack
    }()
    
    private lazy var goToRegistrationLabel: UILabel = {
       let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Еще не имеешь аккаунта? ", attributes: [.font : UIFont(name: Constants.Fonts.Montserrat.medium, size: 12)!, .foregroundColor: UIColor.black])
        
        let registrationLink = NSAttributedString(string: "Зарегистрируйся", attributes: [.font: UIFont(name: Constants.Fonts.Montserrat.bold, size: 12)!, .foregroundColor: UIColor.black])
        
        attributedText.append(registrationLink)
        
        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabelToRegistration))
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    private lazy var blur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = view.frame
        blur.alpha = 0
        return blur
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.9, animations:  {
            self.bottomWhiteView.snp.updateConstraints { make in
                make.top.equalTo(self.filmImageWithDesc.snp.bottom)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(filmImageWithDesc)
        
        filmImageWithDesc.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.70)
        }
        
        view.addSubview(appInfoLabel)

        appInfoLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-32)
        }
        
        view.addSubview(bottomWhiteView)
        
        bottomWhiteView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(filmImageWithDesc.snp.bottom).offset(view.frame.height * 0.2)
        }
        
        bottomWhiteView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(view.frame.height * 0.05)
        }
        
        bottomWhiteView.addSubview(loginBttStack)
        
        loginBttStack.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        bottomWhiteView.addSubview(goToRegistrationLabel)
        
        goToRegistrationLabel.snp.makeConstraints { make in
            make.top.equalTo(loginBttStack.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func showBlur() {
        view.addSubview(blur)
        view.bringSubviewToFront(blur)
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.blur.alpha = 1
        }
        
        view.layoutSubviews()
    }
    
    private func removeBlur() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.blur.alpha = 0
        }
        
        blur.removeFromSuperview()
        view.layoutSubviews()
    }
    
    //MARK: - Selectors
    
    @objc private func presentModal(sender: UIButton) {
        let loginViewController = LoginViewController()
        loginViewController.delegate = delegate
        let nav = UINavigationController(rootViewController: loginViewController)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.preferredCornerRadius = 14
            sheet.detents = [.medium()]
        }
        
        let barItem = UIBarButtonItem(image: UIImage(systemName: "multiply")?.withTintColor(.black, renderingMode: .alwaysOriginal), primaryAction: UIAction(handler: { _ in
            self.removeBlur()
            self.dismiss(animated: true)
        }))
        
        loginViewController.navigationItem.setRightBarButton(barItem, animated: true)
        showBlur()
        present(nav, animated: true)
    }
    
    @objc private func didTapLabelToRegistration(sender: UITapGestureRecognizer) {
        let notTapText = "Еще не имеешь аккауна? "
        let tapText = "Зарегестрируйся"
        if sender.didTapAttributedTextInLabel(label: goToRegistrationLabel, inRange: NSRange(location: notTapText.count, length: tapText.count + 1)) {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            let vc = RegisterViewController()
            vc.delegate = delegate
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Not working!")
        }
    }
    
}
