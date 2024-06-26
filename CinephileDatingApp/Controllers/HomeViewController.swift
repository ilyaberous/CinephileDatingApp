//
//  ViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 06.04.2024.
//

import UIKit
import Firebase
import JGProgressHUD


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User? {
        didSet {
            fetchUsers()
        }
    }
    var viewModels = [CardViewModel]() {
        didSet {
            print("DEBUG: users \(viewModels)")
            setupCards()
        }
    }
    
    lazy var verticalStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        [topStack, cardTemplateView, bottomStack].forEach { el in
            stack.addArrangedSubview(el)
        }
        
        stack.bringSubviewToFront(cardTemplateView)
        
        return stack
    }()
    
    let cardTemplateView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var topStack = HomeNavigationStackView(frame: .zero, superview: view)
    lazy var bottomStack = HomeActionsStackView(frame: .zero, superview: view)
    
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    lazy var updateDataQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "user_data_update")
        queue.async {
            self.fetchUser()
        }
        
        queue.async {
            self.fetchUsers()
        }
        return queue
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIsUserLoggedIn()
        setupUI()
        setupDelegates()
        print("DEBUG: fetch users was called")
    }
    
    // MARK: - Firebase Methods
    
    private func fetchUsers() {
        guard let user = user else { return }
        print("DEBUG: user for viewModels: \(user.name)")
        DataService.shared.fetchUsers(for: user) { users in
            print("DEBUG: \(users)")
            self.viewModels = users.map({ anotherUser in
                    return CardViewModel(user: anotherUser)
            })
            print("DEBUG: View models count \(self.viewModels.count)")
        }
        
        print("DEBUG: View models count \(self.viewModels.count)")
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DataService.shared.fetchUser(withUid: uid) { user in
            self.user = user
            print("DEBUG: user \(user.name) set")
            //self.fetchUsers()
        }
        print("DEBUG: fetchUser finished")
    }
    
    private func checkIsUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentStartViewController()
        } else {
            fetchUser()
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        DataService.shared.saveSwipe(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            guard didLike == true else { return }
            
            DataService.shared.checkIfMatchExists(forUser: user) { didMatch in
                print("DEBUG: Users did match..")
                guard let currentUser = self.user else { return }
                self.presentMatchViewController(for: currentUser, and: user)
                
                DataService.shared.uploadMatch(user: currentUser, matchedUser: user)
            }
        }
    }
    
    //MARK: - Helpers
    
    private func clearHomeView() {
        cardTemplateView.subviews.forEach { $0.removeFromSuperview() }
        view.layoutSubviews()
    }
    
    private func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1,
                       options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: (self.topCardView?.frame.width)!, height: (self.topCardView?.frame.height)!)
        }) { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
    
    private func setupDelegates() {
        topStack.delegate = self
        bottomStack.delegate = self
    }
    
    private func presentStartViewController() {
        DispatchQueue.main.async {
            let vc = StartViewController()
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }
    
    // MARK: - Setup UI
    
    private func setupCards() {
        clearHomeView()
        viewModels.forEach { viewModel in
            let card = CardView(viewModel: viewModel)
            cardTemplateView.addSubview(card)
            card.delegate = self
            card.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        cardViews = cardTemplateView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(verticalStack)
        
        setupVerticalStackConstraints()
    }
    
    private func setupVerticalStackConstraints() {
        cardTemplateView.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom)
        }
        
        bottomStack.snp.makeConstraints { make in
            make.top.equalTo(cardTemplateView.snp.bottom)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        print("DEBUG: setuped UI ")

    }
    
    private func presentMatchViewController(for user: User, and matchedUser: User) {
        let matchVC = MatchViewController(viewModel: MatchViewModel(user: user, matchUser: matchedUser))
        matchVC.delegate = self
        
        let nav = UINavigationController(rootViewController: matchVC)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .coverVertical
        
        let barItem = UIBarButtonItem(image: UIImage(systemName: "multiply")?.withTintColor(.black, renderingMode: .alwaysOriginal), primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        
        matchVC.navigationItem.setRightBarButton(barItem, animated: true)
        present(nav, animated: true)
    }
}

// MARK: - HomeNavigationStackView Delegate Methods

extension HomeViewController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user = self.user else { return }
        let vc = ProfileSettingsViewController(user: user)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func showMessages() {
        guard let user = self.user else { return }
        let vc = MessagesViewController(user: user)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
}

// MARK: - ProfileSettingsController Delegate Methods

extension HomeViewController: ProfileSettingsControllerDelegate {
    func settingsControllerWantsToLogOut(_ controller: ProfileSettingsViewController) {
        controller.dismiss(animated: true)
        logOut()
        print("DEBUG: users: \(viewModels.count)")
        checkIsUserLoggedIn()
        clearHomeView()
    }
    
    func settingsController(_ controller: ProfileSettingsViewController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        print(user.age)
    }
}

// MARK: - CardView Delegate Methods

extension HomeViewController: CardViewDelegate {
    func cardView(_ cardView: CardView, didLikeUser: Bool) {
        cardView.removeFromSuperview()
        print("DEBUG: cardview with name \(cardView.viewModel.user.name) was deleted")
        self.cardViews.removeAll(where: { cardView == $0} )
        
        print("DEBUG: cardviews count: \(cardViews.count)")
        cardViews.forEach { el in print(el) }
        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        
        self.topCardView = cardViews.last
    }
    
    func cardView(_ cardView: CardView, wantsToShowUserProfileFor user: User) {
        let vc = UserProfileViewController(user: user)//UserProfileViewController(user: user)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - HomeStackView Delegate Methods

extension HomeViewController: HomeActionsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: true)
        
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
        print("DEBUG: like user \(topCard.viewModel.user.name)")
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        DataService.shared.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
        print("DEBUG: handle")
    }
    
    func handleRefresh() {
        fetchUser()
        view.layoutSubviews()
        print("DEBUG: handle")
    }
    
}

// MARK: - Login and Register Delegate Methods

extension HomeViewController: LoginRegisterDelegate {
    func switchAppToNewUser() {
        fetchUser()
    }
}


// MARK: - UserProfileViewController Delegate Methods

extension HomeViewController: UserProfileViewControllerDelegate {
    func profileController(_ controller: UserProfileViewController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: UserProfileViewController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            DataService.shared.saveSwipe(forUser: user, isLike: false, completion: nil)
        }
    }
    
    
}


// MARK: - MatchViewController Delegate Methods

extension HomeViewController: MatchViewControllerDelegate {
    func openMessagesViewController(withClosing controller: MatchViewController) {
        print("DEBUG: match view controller closed!")
        controller.navigationController?.dismiss(animated: true)
        showMessages()
    }
}
