//
//  ChatCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 21.05.2024.
//

import UIKit
import Firebase
import SDWebImage

class ChatCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "chat_cell"
    
    private let image: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .white
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.layer.cornerRadius = 30
        return imgV
    }()
    
    private let name: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.Montserrat.bold, size: 14)
        label.textColor = .black
        return label
    }()
    
    private let sendTime: UILabel = {
       let time = UILabel()
        time.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 12)
        time.textColor = .lightGray
        return time
    }()
    
    private lazy var nameTimeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [name, UIView(), sendTime])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fill
        return stack
    }()
    
    private let lastMessage: UILabel = {
        let message = UILabel()
         message.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 15)
         message.textColor = .lightGray
         message.numberOfLines = 2
         return message
    }()
    
    private let circleIfNew: UIView = {
       let circle = UIView()
        circle.snp.makeConstraints { make in make.width.height.equalTo(12) }
        circle.backgroundColor = .systemRed
        circle.layer.cornerRadius = 6
        return circle
    }()
    
    private lazy var lastMessageCircleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lastMessage, UIView(), circleIfNew])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        return stack
    }()
    
    private lazy var globalVerticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTimeStack, lastMessageCircleStack])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var globalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [image, globalVerticalStack])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 16
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        print("DEBUG: cell loaded!")
        addSubview(image)
        image.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        addSubview(globalStack)
        globalStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    public func configure(with chat: Chat, and user: User) {
        print("DEBUG: chat avatar is \(chat.profileImageURL.debugDescription)")
        image.sd_setImage(with: URL(string: chat.profileImageURL))
        name.text = chat.name
        sendTime.text = convertTimestampToRightDateString(from: chat.lastMessageTimestamp)
        lastMessage.text = chat.lastMessage
        
        if chat.authorMessage == user.uid {
            lastMessage.text = "Вы: \(chat.lastMessage!)"
        } else {
            lastMessage.text = chat.lastMessage
        }
        
        if chat.authorMessage != user.uid {
            if chat.isRead! {
                circleIfNew.alpha = 0
            } else {
                circleIfNew.alpha = 1
            }
        } else {
            circleIfNew.alpha = 0
        }
    }
    
    private func convertTimestampToRightDateString(from timestamp: Timestamp?) -> String {
        guard let date = timestamp?.dateValue() else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTimeZoneStr = formatter.string(from: date)
        return formattedTimeZoneStr
    }
}
