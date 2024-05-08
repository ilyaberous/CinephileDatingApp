//
//  ViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 06.04.2024.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User?
    var viewModels = [CardViewModel?]() {
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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIsUserLoggedIn()
        //logOut()
        setupUI()
        setupDelegates()
//        fetchUsers()
//        fetchUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardTemplateView.subviews.forEach { $0.removeFromSuperview() }
        view.layoutSubviews()
        //templateView.subviews.forEach { $0.removeFromSuperview() }
        //view.layoutSubviews()
        checkIsUserLoggedIn()
        fetchUser()
        fetchUsers()
    }
    
    // MARK: - FirebaseAuth Methods
    
    private func fetchUsers() {
        Service.fetchUsers { users in
            print("DEBUG: \(users)")
            self.viewModels = users.map({ user in
                if user.uid != self.user?.uid {
                    return CardViewModel(user: user)
                }
                
                return nil
            })
            print("DEBUG: View models count \(self.viewModels.count)")
        }
        
        print("DEBUG: View models count \(self.viewModels.count)")
    }
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    private func checkIsUserLoggedIn() {
        if Auth.auth().currentUser == nil {
//            clearHomeView()
            presentStartViewController()
        } else {
            print("DEBUG: User is logged in \(Auth.auth().currentUser?.email)")
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    //MARK: - Helper Methods
    
    private func clearHomeView() {
        cardTemplateView.subviews.forEach { $0.removeFromSuperview() }
        view.layoutSubviews()
        self.user = nil
        self.viewModels = []
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
            let vc = UINavigationController(rootViewController: StartViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    // MARK: - Setup UI
    
    private func setupCards() {
        viewModels.forEach { viewModel in
            guard let viewModel = viewModel else {
                return
            }
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
        print("DEBUG: show messages")
    }
    
    
}

// MARK: - ProfileSettingsController Delegate Methods

extension HomeViewController: ProfileSettingsControllerDelegate {
    func settingsControllerWantsToLogOut(_ controller: ProfileSettingsViewController) {
        controller.dismiss(animated: true)
        logOut()
        clearHomeView()
        checkIsUserLoggedIn()
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
        self.cardViews.removeAll(where: { view == $0} )
        
        guard let user = topCardView?.viewModel.user else { return }
        Service.saveSwipe(forUser: user, isLike: didLikeUser)
        
        self.topCardView = cardViews.last
    }
    
    func cardView(_ cardView: CardView, wantsToShowUserProfileFor user: User) {
        let vc = UserProfileViewController(user: user)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension HomeViewController: HomeActionsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: true)
        
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: true)
        print("DEBUG: like user \(topCard.viewModel.user.name)")
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false)
        print("DEBUG: handle")
    }
    
    func handleRefresh() {
        setupCards()
        //зачем??
        view.layoutSubviews()
        print("DEBUG: handle")
    }
    
    
}

