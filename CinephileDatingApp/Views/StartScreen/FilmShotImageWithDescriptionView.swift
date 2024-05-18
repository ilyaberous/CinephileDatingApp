//
//  FilmShotImageWithTitle.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.04.2024.
//

import UIKit

class FilmShotImageWithDescriptionView: UIView {
    
    //MARK: - Properties
    
    private var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 16)
        return label
    }()

    private var descLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.34)
        label.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 12)
        return label
    }()
    
    private lazy var stack: UIStackView = {
       let sv = UIStackView()
        sv.axis = .vertical
        sv.contentMode = .left
        sv.spacing = 4
        
        [self.titleLabel, self.descLabel].forEach { label in sv.addArrangedSubview(label) }
        return sv
    }()
    
    private var imageV: UIImageView = {
       let imgV = UIImageView()
        imgV.image?.withRenderingMode(.alwaysOriginal)
        return imgV
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    //MARK: - LifeCycle
    
    init(title: String, director: String, year: Int, image: UIImage) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        
        // ERROR: - Выполняет функцию ViewModel
        self.descLabel.text = director + ", " + String(year)
        self.imageV.image = image
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        addSubview(imageV)
        
        imageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        configureGradientLayer()
        
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor]
        gradientLayer.locations = [0.7, 0.98]
        layer.addSublayer(gradientLayer)
    }
}
