//
//  HomeNavigationStackView.swift
//  CinephileDatingApp
//
//  Created by Default on 09.04.2024.
//

import UIKit
import SnapKit

protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    var superView: UIView!
    
    lazy var profileButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        btt.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return btt
    }()
    
    let fireImage : UIImageView = {
        let fire = UIImage(named: "app_icon")
        let imageView = UIImageView(image: fire)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let button: UILabel = {
        let btt = UILabel()
        btt.text = "OBSCURA"
        btt.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 24)
        btt.textColor = .black
        return btt
    }()
    
    lazy var messageButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        btt.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        return btt
    }()
    
    //MARK: - Lifecycle
    
    init(frame: CGRect, superview: UIView) {
        super.init(frame: frame)
        self.superView = superview
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        [profileButton, UIView(), button, UIView(), messageButton].forEach { el in
            addArrangedSubview(el)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        
        let height = superView.frame.height * 0.125
        self.snp.makeConstraints { make in make.height.equalTo(height) }
    }
    
    //MARK: - Selectors
    
    @objc private func profileButtonTapped(sender: UIButton) {
        delegate?.showSettings()
    }
    
    @objc private func messageButtonTapped(sender: UIButton) {
        delegate?.showMessages()
    }
}
