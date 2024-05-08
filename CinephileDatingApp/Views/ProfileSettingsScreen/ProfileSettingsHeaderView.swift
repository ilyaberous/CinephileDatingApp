//
//  ProfileSettingsHeaderView.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.04.2024.
//

import UIKit
import SDWebImage

protocol ProfileSettingsDelegate: AnyObject {
    func settingsHeader(_ header: ProfileSettingsHeaderView, didSelect index: Int)
}

class ProfileSettingsHeaderView: UIView {
    
    // MARK: - Properties
    
    var buttons = [UIButton]()
    weak var delegate: ProfileSettingsDelegate?
    private let user: User
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        setupProfileButtons()
        loadUserPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func loadUserPhotos() {
        let imageURLs = user.profileImageURLs.map({ URL(string: $0 )})
        for (index, url) in imageURLs.enumerated() {
            SDWebImageManager.shared().loadImage(with: url, progress: nil) { (image, _, _, _, _, _) in
                self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    private func setupProfileButtons() {
        let btt1 = makePhotoButton(0)
        let btt2 = makePhotoButton(1)
        let btt3 = makePhotoButton(2)
        
        [btt1, btt2, btt3].forEach { btt in buttons.append(btt) }
        
        var vStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [btt2, btt3])
             stack.axis = .vertical
             stack.distribution = .fillEqually
             stack.spacing = 16
             return stack
        }()
        
        addSubview(btt1)
        btt1.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.60)
        }
        
        addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(16)
            make.left.equalTo(btt1.snp.right).offset(12)
        }
        
    }
    
    private func makePhotoButton(_ index: Int) -> UIButton {
        let btt = UIButton(type: .system)
        btt.setImage(UIImage(named: "avatar_form")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btt.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        btt.layer.cornerRadius = 10
        btt.clipsToBounds = true
        btt.backgroundColor = .white
        btt.imageView?.contentMode = .scaleAspectFill
        btt.tag = index
        return btt
    }
    
    // MARK: - Selectors
    
    @objc private func photoButtonTapped(sender: UIButton) {
        delegate?.settingsHeader(self, didSelect: sender.tag)
    }
}
