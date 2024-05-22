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
        listenForChats()
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
        Service.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
    
    func listenForChats() {
        print("DEBUG: listenForCharts!")
        chatsListener = Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document("\(userID!)").collection("chats").order(by: "lastMessageTimestamp", descending: true).addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("DEBUG: Error listening for chats: \(error)")
                return
            }
            
           // print("DEBUG: snapshot documents: \(snapshot?.documents)")
            self.chats = snapshot?.documents.compactMap { document in
                let data = document.data()
                let chat = Chat(
                    //userID: data["userID"] as? String  ?? "",
                    matchedUserID: data["matchedUserID"] as? String ?? "",
                    name: data["name"] as? String  ?? "",
                    profileImageURL: data["profileImageURL"] as? String ?? "",
                    lastMessage: data["lastMessage"] as? String  ?? "",
                    authorMessage: data["authorMessage"] as? String ?? "",
                    lastMessageTimestamp: data["lastMessageTimestamp"] as? Timestamp ?? nil,
                    isRead: data["isRead"] as? Bool ?? false
                    )
                return chat
            } ?? []
        }
    }
    
    private func makeLastMessageRead(messageID: String, matchedUserID: String) {
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(userID!).collection("messages").document(matchedUserID).collection("messages").document(messageID).updateData(
            ["isRead": true]
        )
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(userID!).collection("chats").document(matchedUserID).updateData(
            ["isRead": true]
        )
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(matchedUserID).collection("messages").document(userID!).collection("messages").document(messageID).updateData(
            ["isRead": true]
        )
        
        Constants.Firebase.COLLECTION_MATCHES_MESSAGES.document(matchedUserID).collection("chats").document(userID!).updateData(
            ["isRead": true]
        )
    }
    
    // MARK: - Helpers
    
    private func presentChat(chat: Chat, with user: User) {
        let chatVC = ChatViewController(user: user, chat: chat)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(chatVC, animated: true)
        guard let messageID = chat.lastMessage else { return }
        makeLastMessageRead(messageID: messageID, matchedUserID: chat.matchedUserID)
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
        presentChat(chat: chats[indexPath.row], with: user)
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
        presentChat(chat: Chat(matchedUserID: match.uid, name: match.name, profileImageURL: match.profileImageURL, lastMessage: nil, authorMessage: nil, lastMessageTimestamp: nil, isRead: nil), with: user)
    }
}

