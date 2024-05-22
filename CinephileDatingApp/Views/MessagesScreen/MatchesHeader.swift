//
//  MatchHeader.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.05.2024.
//

import UIKit

protocol MatchesHeaderDelegate: AnyObject {
    func matchesHeaderWantsToPresentChat(withhUser match: Match)
}

class MatchesHeader: UICollectionReusableView {
    
    weak var delegate: MatchesHeaderDelegate?
    
    var matches = [Match]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let newMatchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Новые мэтчи"
        label.textColor = .black
        label.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 18)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(MatchesCell.self, forCellWithReuseIdentifier: MatchesCell.identifier)
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newMatchesLabel)
        newMatchesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(newMatchesLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionView Delegate Methods

extension MatchesHeader: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: did select item : \(matches[indexPath.row].name)")
        delegate?.matchesHeaderWantsToPresentChat(withhUser: matches[indexPath.row])
    }
}

// MARK: - UICollectionView DataSource Methods

extension MatchesHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchesCell.identifier, for: indexPath) as! MatchesCell
        let viewModel = MatchCellViewModel(match: matches[indexPath.row])
        cell.viewModel = viewModel
        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout Methods

extension MatchesHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 124)
    }
}
