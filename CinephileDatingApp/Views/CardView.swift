//
//  CardView.swift
//  CinephileDatingApp
//
//  Created by Default on 12.04.2024.
//

import UIKit

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

class CardView: UIView, CardViewModelDelegate {

    //MARK: - Properties
    
    private var viewModel: CardViewModel
    private let gradientLayer = CAGradientLayer()
    
    private lazy var imageView: UIImageView = {
       let imgV = UIImageView()
        imgV.image = viewModel.user.images.first
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    private lazy var infoLabel: UILabel = {
       let label = UILabel()
        label.attributedText = viewModel.userInfoAttributedText
        label.numberOfLines = 2
        return label
    }()
    
    private let infoButton: UIButton = {
        let btt = UIButton(type: .system)
        let img = UIImage(#imageLiteral(resourceName: "info_icon")).withRenderingMode(.alwaysOriginal)
        btt.setImage(img, for: .normal)
        return btt
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLabel, infoButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    //MARK: - Lifecycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        configureGestureRecognizer()
        self.viewModel.delegate = self
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .green
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        configureGradientLayer()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        infoButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
    }
    
    //MARK: - Helpers
    
    private func  configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    private func configureGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tap)
    }
    
    private func resetCardPosition(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let direction: SwipeDirection = translation.x > 100 ? .right : .left
        let shouldDismissCard = abs(translation.x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    private func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 100
        let rotationTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransform.translatedBy(x: translation.x, y: 0)
    }
    
    
    //MARK: - Selectors
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            superview?.subviews.forEach { view in view.layer.removeAllAnimations() }
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default:
            break
        }
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto{
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
    }
    
    //MARK: - Delegate methods
    
    func setImage(img: UIImage) {
        self.imageView.image = img
    }
    
}
