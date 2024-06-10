//
//  ProfileSettingsViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.04.2024.
//

import UIKit
import JGProgressHUD

protocol ProfileSettingsControllerDelegate: AnyObject {
    func settingsController(_ controller: ProfileSettingsViewController, wantsToUpdate user: User)
    func settingsControllerWantsToLogOut(_ controller: ProfileSettingsViewController)
}

class ProfileSettingsViewController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var headerView = ProfileSettingsHeaderView(user: user)
    private lazy var footerView = ProfileSettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imgIndex = 0
    private var user: User
    private var currentFilmCardTag: Int = 0
    
    weak var delegate: ProfileSettingsControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        headerView.delegate = self
        imagePicker.delegate = self
        footerView.delegate = self
    }
    
    // MARK: - Setup UI
    
    private func setHeaderImage(_ img: UIImage) {
        headerView.buttons[imgIndex].setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Профиль"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        tableView.register(NameAgeCell.self, forCellReuseIdentifier: NameAgeCell.identifier)
        tableView.register(AgeSliderCell.self, forCellReuseIdentifier: AgeSliderCell.identifier)
        tableView.register(BioCell.self, forCellReuseIdentifier: BioCell.identifier)
        tableView.register(FavoriteFilmsCell.self, forCellReuseIdentifier: FavoriteFilmsCell.identifier)
    }
    
    // MARK: - Firebase database
    
    private func uploadImage(img: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Сохранение изображения"
        hud.show(in: view)
        
        let urlsCount = self.user.profileImageURLs.count
        
        DataService.shared.uploadImage(image: img) { imageURL in
            if self.imgIndex <= urlsCount - 1 {
                self.user.profileImageURLs[self.imgIndex] = imageURL
            } else {
                self.user.profileImageURLs.append(imageURL)
            }
            hud.dismiss(animated: true)
        }
    }
    
    
    // MARK: - Selectors
    
    @objc private func cancelTapped(sender: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @objc private func doneTapped(sender: UIBarButtonItem) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Сохранение данных"
        hud.show(in: view)
        
        DataService.shared.saveUserData(user: user) { [weak self] error in
            guard let self = self else { return }
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
            hud.dismiss(animated: true)
        }
    }
    
}

// MARK: - UITableViewDataSource Methods

extension ProfileSettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSections(rawValue: indexPath.section) else { return UITableViewCell() }
        let viewModel = ProfileSettingsViewModel(user: user, section: section)
        
        switch section {
        case .name, .age:
            let nameAgecell = tableView.dequeueReusableCell(withIdentifier: NameAgeCell.identifier) as! NameAgeCell
            nameAgecell.viewModel = viewModel
            nameAgecell.delegate = self
            return nameAgecell
        case .bio:
            let bioCell = tableView.dequeueReusableCell(withIdentifier: BioCell.identifier) as! BioCell
            bioCell.viewModel = viewModel
            bioCell.delegate = self
            return bioCell
        case .favoriteFilms:
            let favoriteFilmsCell = tableView.dequeueReusableCell(withIdentifier: FavoriteFilmsCell.identifier) as! FavoriteFilmsCell
            favoriteFilmsCell.delegate = self
            let viewModel = FavoriteFilmsViewModel(user: user)
            favoriteFilmsCell.viewModel = viewModel
            return favoriteFilmsCell
        case .ageRange:
            let ageSliderCell = tableView.dequeueReusableCell(withIdentifier: AgeSliderCell.identifier) as! AgeSliderCell
            ageSliderCell.viewModel = viewModel
            ageSliderCell.delegate = self
            return ageSliderCell
        }

    }
}

// MARK: - UITableViewDelegate Methods

extension ProfileSettingsViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSections(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .name, .age:
            return 44
        case .ageRange:
            return 96
        case .bio:
            return 150
        case .favoriteFilms:
            return ((self.view.frame.width - 32) / 4) * 1.5
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }
}

// MARK: - ProfileSettingDelegate Methods

extension ProfileSettingsViewController: ProfileSettingsDelegate {
    func settingsHeader(_ header: ProfileSettingsHeaderView, didSelect index: Int) {
        imgIndex = index
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerController Delegate Methods

extension ProfileSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[.originalImage] as? UIImage else {
            return
        }
        
        uploadImage(img: selectedPhoto)
        setHeaderImage(selectedPhoto)
        print("DEBUG: Picker photo")
        dismiss(animated: true)
    }
}

// MARK: - ProfileSettingsCell Delegate Methods

extension ProfileSettingsViewController: ProfileSettingsCellDelegate {
    func settingsCell(_ cell: UITableViewCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        guard let cell = cell as? AgeSliderCell else { return }
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCell(_ cell: UITableViewCell, wantsToUpdateUserWith value: String, for section: SettingsSections) {
        switch section {
        case .name:
            user.name = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .favoriteFilms, .ageRange:
            break
        }
    }
}

// MARK: - ProfileSettingsFooterView Delegate Methods

extension ProfileSettingsViewController: ProfileSettingsFooterDelegate {
    func handleLogOut() {
        delegate?.settingsControllerWantsToLogOut(self)
    }
}

// MARK: - FavoriteFilmsCell Delegate Methods


extension ProfileSettingsViewController: FavoriteFilmsCellDelegate {
    func favoriteFilmCell(_ cell: FavoriteFilmsCell, wantsToPresentSearchViewControllerForFilmCardWith tag: Int) {
        self.currentFilmCardTag = tag
        let vc = SearchFilmsViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - SearchViewController Delegate Methods

extension ProfileSettingsViewController: SearchFilmsViewControllerDelegate {
    func searchFilmsController(_ controller: SearchFilmsViewController, wantsToUpdateFavoriteFilmsWith filmTuple: (url: String?, imgURL: String?)) {
        guard let url = filmTuple.url, let poster = filmTuple.imgURL else { return }
        user.favoriteFilmsURLs[currentFilmCardTag] = url
        user.favoriteFilmsImagesURLs[currentFilmCardTag] = poster
        tableView.reloadData()
        controller.dismiss(animated: true)
    }
}
