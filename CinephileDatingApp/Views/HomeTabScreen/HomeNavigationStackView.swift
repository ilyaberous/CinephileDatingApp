//
//  HomeNavigationStackView.swift
//  CinephileDatingApp
//
//  Created by Default on 09.04.2024.
//

import UIKit
import SnapKit

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    var superView: UIView!
    
    let profileButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        return btt
    }()
    
    let fireImage : UIImageView = {
        let fire = UIImage(named: "app_icon")
        let imageView = UIImageView(image: fire)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let messageButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
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
        [profileButton, UIView(), fireImage, UIView(), messageButton].forEach { el in
            addArrangedSubview(el)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        
        let height = superView.frame.height * 0.125
        self.snp.makeConstraints { make in make.height.equalTo(height) }
    }
}
