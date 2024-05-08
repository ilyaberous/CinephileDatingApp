//
//  userProfileCollectionViewCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 24.04.2024.
//

import UIKit

class userProfileCollectionViewCell: UICollectionViewCell {

    static let identifier = "user_profile_cell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
