//
//  ChatViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.05.2024.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

struct Message: MessageType {
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
    let isRead: Bool
}

struct FirestoreMessage {
    let senderID: String
    let messageID: String
    let text: String
    let timestamp: Timestamp
    let isRead: Bool
}

struct Chat {
    let matchedUserID: String
    let name: String
    let profileImageURL: String
    let lastMessage: String?
    let authorMessage: String?
    let lastMessageTimestamp: Timestamp?
    let isRead: Bool?
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class ChatViewController: MessageKit.MessagesViewController {
    
    // MARK: - Properties
    
    let user: User
    var chat: Chat
    let userID = Auth.auth().currentUser?.uid
    var messages = [MessageType]() {
        didSet {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    var messagesListener: ListenerRegistration?
    
    private let companionImage: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        imgV.layer.cornerRadius = 17
        return imgV
    }()
    
    private let companionName: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 20)
        name.textColor = .black
        return name
    }()
    
    // MARK: - Lifecycle
    
    init(user: User, chat: Chat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupDelegates()
        configureMessagesControllerAndCollectionView()
        configureMessageInputBar()
        configureMessagesListener()
    }
    
    // MARK: - SetupUI
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = companionName
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: companionImage)
        configureNavigationBarImageAndName()
    }
    
    // MARK: - MessagesService Methods
    
    private func configureMessagesListener() {
        messagesListener = MessagesService.shared.createMessagesListener(userID: user.uid, companionID: chat.matchedUserID)
        { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let messages):
                self?.messages = messages
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    private func configureNavigationBarImageAndName() {
        companionImage.sd_setImage(with: URL(string: chat.profileImageURL))
        companionName.text = chat.name
        navigationController?.navigationBar.layoutSubviews()
    }
    
    private func configureMessagesControllerAndCollectionView() {
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        
        self.scrollsToLastItemOnKeyboardBeginsEditing = true
        self.maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
    }
    
    private func configureMessageInputBar() {
        let addMediaButton = InputBarButtonItem(type: .system)
        //addMediaButton.layer.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let mediaIMG = UIImage(systemName: "film.stack")?.withRenderingMode(.alwaysOriginal)
        addMediaButton.setImage(mediaIMG, for: .normal)
        addMediaButton.imageView?.contentMode = .scaleAspectFill
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.leftStackView.alignment = .center
        //messageInputBar.leftStackView.backgroundColor = .gray
        messageInputBar.setStackViewItems([addMediaButton], forStack: .left, animated: true)
        
        let sendButton = InputBarButtonItem(type: .system)
        //sendButton.layer.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let sendIMG = UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal)
        sendButton.setImage(sendIMG, for: .normal)
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.onTouchUpInside() { [weak self] _ in
            guard let self else {
                return
            }
            guard let text = self.messageInputBar.inputTextView.text else {
                return
            }
            MessagesService.shared.createMessage(sender: self.user, companion: User(dict: ["name": self.chat.name, "uid": self.chat.matchedUserID, "profileImageURLs": [self.chat.profileImageURL]]), text: text.trimmingCharacters(in: .whitespacesAndNewlines)) { error in
                print(error.localizedDescription)
            }
            self.messageInputBar.inputTextView.text = ""
        }
        messageInputBar.setRightStackViewWidthConstant(to: 35, animated: true)
        messageInputBar.rightStackView.alignment = .center
        //messageInputBar.rightStackView.backgroundColor = .gray
        messageInputBar.setStackViewItems([sendButton], forStack: .right, animated: true)
        
        messageInputBar.inputTextView.layer.borderWidth = 0.5
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputBar.inputTextView.layer.cornerRadius = 16
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        messageInputBar.inputTextView.placeholder = "Сообщение"
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 8)
        
        reloadInputViews()
    }
}

// MARK: - Messages Data Source

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: userID!, displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

// MARK: - Messages Layout Delegate

extension ChatViewController: MessagesLayoutDelegate {
}

// MARK: - Messages Display Delegate

extension ChatViewController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.image = companionImage.image
    }
    
    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let messageDate = messages[indexPath.section].sentDate
               let formatter = DateFormatter()
               formatter.dateFormat = "HH:mm"
               let dateString = formatter.string(from: messageDate)
        print("DEBUG: messageDtae: \(messageDate)")
               return
                   NSAttributedString(string: dateString, attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .orange : .systemGray6
    }
}

// MARK: - InputBarAccessoryView Delegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    }
}

