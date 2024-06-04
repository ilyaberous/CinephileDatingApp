//
//  UserProfileHeader.swift
//  CinephileDatingApp
//
//  Created by Ilya on 04.06.2024.
//

import UIKit

class UserProfileHeader: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(UserProfileCollectionCell.self,
                    forCellWithReuseIdentifier: UserProfileCollectionCell.identifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionViewDelegate<T: UICollectionViewDelegate & UICollectionViewDataSource>(delegate: T) {
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
    }
}
