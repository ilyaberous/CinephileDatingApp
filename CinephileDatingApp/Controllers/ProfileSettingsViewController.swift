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
        tableView.register(ProfileSettingsCell.self, forCellReuseIdentifier: ProfileSettingsCell.identifier)
    }
    
    // MARK: - Firebase database
    
    private func uploadImage(img: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Сохранение изображения"
        hud.show(in: view)
        
        let urlsCount = self.user.profileImageURLs.count
        
        Service.uploadImage(image: img) { imageURL in
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
        
        Service.saveUserData(user: user) { [weak self] error in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingsCell.identifier, for: indexPath) as! ProfileSettingsCell
        
        guard let section = SettingsSections(rawValue: indexPath.section) else { return cell }
        let viewModel = ProfileSettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
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
        return section == .ageRange ? 96 : 44
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
    func settingsCell(_ cell: ProfileSettingsCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCell(_ cell: ProfileSettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSections) {
        switch section {
        case .name:
            user.name = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .favoriteFilms, .ageRange:
            print("adadsdads")
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
