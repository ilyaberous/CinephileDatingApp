//
//  MessegesViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.05.2024.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {

    // MARK: - Properties
    
    let identifire = "cell"
    
    private let user: User
    
    private var chats = [Chat]() {
        didSet {
            //print("DEBUG: chats count: \(chats[1].name)")
            tableView.reloadData()
        }
    }
    
    private let userID = Auth.auth().currentUser?.uid
    private var chatsListener: ListenerRegistration?
    
    private let headerView = MatchesHeader()
    
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
        configureTableView()
        configureNavigationBar()
        fetchMatches()
        createChatsListener()
    }
    
    // MARK: - SetupUI
    
    private func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        headerView.delegate = self
        tableView.tableHeaderView = headerView
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Диалоги"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButton = UIImageView()
        backButton.image = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        backButton.contentMode = .scaleAspectFill
        backButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        backButton.tintColor = .black
        backButton.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - Firebase
    
    func fetchMatches() {
        DataService.shared.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
    
    func createChatsListener() {
        print("DEBUG: listenForCharts!")
        chatsListener = MessagesService.shared.createChatsListener(userID: self.userID!) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let chats):
                self?.chats = chats
                print("DEBUG: chats \(chats.first?.name)")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func presentChatViewController(chat: Chat, with user: User) {
        let chatVC = ChatViewController(user: user, chat: chat)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(chatVC, animated: true)
        guard let messageID = chat.lastMessage else { return }
        MessagesService.shared.makeMessageRead(messageID: messageID, userID: userID!, matchedUserID: chat.matchedUserID)
    }
    
    // MARK: - Selectors
    
    @objc private func backTapped(sender: UIImageView) {
        dismiss(animated: true)
    }
}

// MARK: - UITableView DataSource Methods

extension MessagesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        cell.configure(with: chats[indexPath.row], and: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentChatViewController(chat: chats[indexPath.row], with: user)
    }
}

// MARK: - UITableView Delegate Methods

extension MessagesViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.text = "Сообщения"
        label.textColor = .black
        label.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 18)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(16)
        }
        
        return view
    }
}

// MARK: - MatchesHeader Delegate Methods

extension MessagesViewController: MatchesHeaderDelegate {
    func matchesHeaderWantsToPresentChat(withhUser match: Match) {
        presentChatViewController(chat: Chat(matchedUserID: match.uid, name: match.name, profileImageURL: match.profileImageURL, lastMessage: nil, authorMessage: nil, lastMessageTimestamp: nil, isRead: nil), with: user)
    }
}

