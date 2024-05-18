//
//  UserProfileViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 24.04.2024.
//

import UIKit

protocol UserProfileViewControllerDelegate: AnyObject {
    func profileController(_ controller: UserProfileViewController, didLikeUser user: User)
    func profileController(_ controller: UserProfileViewController, didDislikeUser user: User)
}

class UserProfileViewController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: UserProfileViewControllerDelegate?
    
    private let user: User
    
    private lazy var viewModel = UserProfileViewModel(user: user)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UserProfileCollectionCell.self,
                    forCellWithReuseIdentifier: UserProfileCollectionCell.identifier)
        return cv
    }()
    
    private lazy var dismissButton: UIButton = {
        let btt = UIButton(type: .system)
        btt.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        btt.addTarget(self, action: #selector(dissmisButtonTapped), for: .touchUpInside)
        return btt
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 32)
        return label
    }()
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 18)
        return label
    }()
    
    private let titleForBio: UILabel = {
       let label = UILabel()
        label.text = "О себе"
        label.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 24)
        return label
    }()
    
    private lazy var bioStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleForBio, bioLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.contentMode = .left
        return stack
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLabel, bioStack])
         stack.axis = .vertical
         stack.spacing = 16
         stack.contentMode = .left
         return stack
    }()
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageCountForProgressBar)
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        configureBarStackView()
        
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(collectionView.snp.bottom).offset(-20)
            make.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        configureBottomControlls()
    }
    
    private func configureBottomControlls() {
        lazy var dislike: UIButton = {
          let btt = createButton(withImage: #imageLiteral(resourceName: "dismiss_circle"))
            btt.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
            return btt
        }()
        
        lazy var superLike: UIButton = {
            let btt = createButton(withImage: #imageLiteral(resourceName: "super_like_circle"))
            btt.addTarget(self, action: #selector(superLikeButtonTapped), for: .touchUpInside)
            return btt
        }()
        
        lazy var like: UIButton = {
           let btt = createButton(withImage: #imageLiteral(resourceName: "like_circle"))
            btt.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
            return btt
        }()
        
        let stack = UIStackView(arrangedSubviews: [dislike, superLike, like])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = -32
        
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 80))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
        }
    }
    
    private func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.snp.makeConstraints { make in
            make.left.right.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(4)
        }
        
    }
    
    private func createButton(withImage img: UIImage) -> UIButton {
        let btt = UIButton(type: .system)
        btt.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
        btt.imageView?.contentMode = .scaleAspectFill
        return btt
    }
    
    // MARK: - Helpers
    
    private func loadUserData() {
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        bioLabel.text = viewModel.bio
    }
    
    // MARK: - Selectors
    
    @objc private func dissmisButtonTapped(sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func dislikeButtonTapped(sender: UIButton) {
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc private func superLikeButtonTapped(sender: UIButton) {
        
    }
    
    @objc private func likeButtonTapped(sender: UIButton) {
        delegate?.profileController(self, didLikeUser: user)
    }
}

// MARK: - CollectionView DataSource Methods

extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: UserProfileCollectionCell.identifier, for: indexPath) as! UserProfileCollectionCell
        
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        print("DEBUG: view is \(view.frame.width), collectioview is \(cell.imageView.frame.width)")
        return cell
    }
}

// MARK: - CollectionView Delegate Methods

extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.imageCountForProgressBar != 0 else {
            return
        }
        barStackView.setHighlighted(index: indexPath.row)
        print(indexPath.row)
    }
}

// MARK: - CollectionView DelegateFlowLayout Methods

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
