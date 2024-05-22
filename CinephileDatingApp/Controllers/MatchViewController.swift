//
//  MatchViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 19.05.2024.
//

import UIKit

protocol MatchViewControllerDelegate: AnyObject {
    func openMessagesViewController(withClosing controller: MatchViewController)
}

class MatchViewController: UIViewController {

    weak var delegate: MatchViewControllerDelegate?
    
    private let viewModel: MatchViewModel
    
    private lazy var userImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        return imageV
    }()
    
    private lazy var matchedUserImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        return imageV
    }()
    
    private lazy var labelsStack: UIStackView = {
        let label1 = UILabel()
        label1.text = "Поздравляем!"
        label1.textAlignment = .center
        label1.textColor = .black
        label1.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 38)
        
        let label2 = UILabel()
        label2.text = viewModel.matchLabelText
        label2.textAlignment = .center
        label2.numberOfLines = 2
        label2.textColor = .black
        label2.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 24)
        
        let stack = UIStackView(arrangedSubviews: [label1, label2])
        stack.axis = .vertical
        stack.spacing = 16
        
        return stack
    }()
    
    private lazy var button: UIButton = {
       let btt = UIButton()
        btt.setTitleColor(.white, for: .normal)
        btt.backgroundColor = .black
        
        let font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        let attributedTitle = NSAttributedString(string: "Перейти к диалогу", attributes: [.font: font])
        btt.setAttributedTitle(attributedTitle, for: .normal)
        
        btt.layer.cornerRadius = 8
        
        btt.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btt
    }()
    
    private lazy var blurView: UIVisualEffectView = {
       let view = UIVisualEffectView()
        view.frame = self.view.bounds
        let blur = UIBlurEffect(style: .light)
        view.effect = blur
        return view
    }()

    init(viewModel: MatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        matchedUserImageView.layer.cornerRadius = matchedUserImageView.frame.height / 2
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(blurView)
        
        view.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-45)
            make.centerY.equalToSuperview().offset(-view.frame.height / 4)
            make.width.height.equalTo(180)
        }
        
        view.addSubview(matchedUserImageView)
        matchedUserImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(45)
            make.centerY.equalToSuperview().offset((-view.frame.height / 4) + 25)
            make.width.height.equalTo(180)
        }
        
        loadAndConfigureImages()
        
        view.addSubview(labelsStack)
        labelsStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func loadAndConfigureImages() {
        userImageView.sd_setImage(with: viewModel.userImageURL) { [weak self] _,_,_,_ in
            guard let self = self else { return }
            guard var image = self.userImageView.image else { return }
            image.withRenderingMode(.alwaysOriginal)
        }
        
        matchedUserImageView.sd_setImage(with: viewModel.matchedUserImageURL) { [weak self] _,_,_,_ in
            guard let self = self else { return }
            guard var image = self.matchedUserImageView.image else { return }
            image.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc private func buttonTapped() {
        print("DEBUG: butto tapped!")
        delegate?.openMessagesViewController(withClosing: self)
    }
}
