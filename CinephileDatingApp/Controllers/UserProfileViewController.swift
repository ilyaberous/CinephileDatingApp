//
//  UserProfileController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 04.06.2024.
//

import UIKit

protocol UserProfileViewControllerDelegate: AnyObject {
    func profileController(_ controller: UserProfileViewController, didLikeUser user: User)
    func profileController(_ controller: UserProfileViewController, didDislikeUser user: User)
}

class UserProfileViewController: UITableViewController {
    
    weak var delegate: UserProfileViewControllerDelegate?
    
    private let user: User
    
    lazy private var viewModel = UserProfileViewModel(user: user)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UserProfileCollectionCell.self,
                    forCellWithReuseIdentifier: UserProfileCollectionCell.identifier)
        return cv
    }()
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageCountForProgressBar)
    
    private lazy var dismissButton: UIButton = {
        let btt = UIButton(type: .system)
        btt.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        btt.addTarget(self, action: #selector(dissmisButtonTapped), for: .touchUpInside)
        return btt
    }()
    
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
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        

        tableView.tableHeaderView = makeHeaderView()
        tableView.tableFooterView = makeFooterView()
        tableView.register(UserProfileInfoTableCell.self, forCellReuseIdentifier: UserProfileInfoTableCell.identifier)
        tableView.register(UserProfileBioTableCell.self, forCellReuseIdentifier: UserProfileBioTableCell.identifier)
        tableView.register(UserProfileFavoriteFilmsTableCell.self, forCellReuseIdentifier: UserProfileFavoriteFilmsTableCell.identifier)
    }
    
    private func makeHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        header.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        header.addSubview(barStackView)
        barStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(8)
            make.height.equalTo(4)
        }
        
        header.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(header.snp.bottom).offset(-20)
            make.right.equalToSuperview().inset(16)
        }
    
        return header
    }
    
    private func makeFooterView() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        
        let stack = UIStackView(arrangedSubviews: makeBottomControlButtons())
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = -32
        
        footer.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 80))
            make.centerX.equalTo(footer.snp.centerX)
            make.centerY.equalTo(footer.snp.centerY)
        }
        
        return footer
    }
    
    private func makeBottomControlButtons() -> [UIButton] {
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
        
        return [dislike, superLike, like]
    }
    
    private func createButton(withImage img: UIImage) -> UIButton {
        let btt = UIButton(type: .system)
        btt.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
        btt.imageView?.contentMode = .scaleAspectFill
        return btt
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
    
    

// MARK: - TableView DataSource Methods

extension UserProfileViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = UserProfileSections(rawValue: indexPath.section) else { return UITableViewCell() }
        let viewModel = UserProfileViewModel(user: user)
        
        switch section {
        case .info:
            let cell = UserProfileInfoTableCell()
            cell.viewModel = viewModel
            return cell
        case .bio:
            let cell = UserProfileBioTableCell()
            cell.viewModel = viewModel
            return cell
        case .favoriteFilms:
            let cell = UserProfileFavoriteFilmsTableCell()
            cell.delegate = self
            cell.viewModel = viewModel
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return UserProfileSections.allCases.count
    }
}

// MARK: - TableViewDelegate Methods

extension UserProfileViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = UserProfileSections(rawValue: section) else { return 0 }
        switch section {
            case .info: return 0
            case .bio, .favoriteFilms: return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = UserProfileSections(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = UserProfileSections(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .info:
            return 44
        case .bio:
            return UITableView.automaticDimension
        case .favoriteFilms:
            return ((self.view.frame.width - 32) / 4) * 1.7
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerInSection = PaddingLabel(withInsets: 0, 0, 16, 16)
        headerInSection.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 22)
        
        guard let section = UserProfileSections(rawValue: section) else { return nil }
        headerInSection.text = section.description
        switch section {
        case .info:
            return nil
        case .bio, .favoriteFilms:
            return headerInSection
        }
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

// MARK: - CollectionViewDelegate FlowLayout Methods

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
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

// MARK: - CollectionView Delegate Methods

extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.imageCountForProgressBar != 0 else {
            return
        }
        
        barStackView.setHighlighted(index: indexPath.row)
    }
}

// MARK: - FilmStackDelegate Methods

extension UserProfileViewController: UserProfileFavoriteFilmsCellDelegate {
    func favoriteFilmCell(_ cell: UserProfileFavoriteFilmsTableCell, wantsToPresentFilmPageViewControllerForFilmCardWith tag: Int) {
        let filmURL = user.favoriteFilmsURLs[tag]
        let wv = FilmPageViewController(filmURL: filmURL)
        wv.modalPresentationStyle = .pageSheet
        show(wv, sender: nil)
        print("DEBUG: film page present!!")
    }
}
