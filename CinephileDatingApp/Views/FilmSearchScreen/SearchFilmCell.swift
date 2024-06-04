//
//  FilmCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.05.2024.
//

import UIKit

class SearchFilmCell: UICollectionViewCell {
    
    static let ID = "MovieCell"
    
    private var MoviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "house")
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .systemGroupedBackground
        addSubview(MoviePosterImageView)
        MoviePosterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateCell(posterURL: String?){
        if let posterURL = posterURL {
            guard let CompleteURL = URL(string: posterURL) else {return}
            self.MoviePosterImageView.sd_setImage(with: CompleteURL)
        }
    }
}
