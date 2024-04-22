//
//  HomeActionsStackView.swift
//  CinephileDatingApp
//
//  Created by Default on 09.04.2024.
//

import UIKit

class HomeActionsStackView: UIStackView {
    //MARK: - Properties
    
    var superView: UIView!
    let refreshButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = #imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        return btt
    }()
    
    let dislikeButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        return btt
    }()
    
    let superlikeButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        return btt
    }()
    
    let likeButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal)
        btt.setImage(profileImage, for: .normal)
        return btt
    }()
    
    let boostButton: UIButton = {
        let btt = UIButton(type: .system)
        let profileImage = #imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal)
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
        [refreshButton, UIView(), dislikeButton, UIView(), superlikeButton, UIView(), likeButton, UIView(), boostButton].forEach { el in
            addArrangedSubview(el)
        }
        
        let height = superView.frame.height * 0.125
        self.snp.makeConstraints { make in make.height.equalTo(height) }
        
        distribution = .fillProportionally
    }
}
