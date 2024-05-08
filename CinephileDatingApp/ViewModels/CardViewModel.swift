//
//  CardViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 15.04.2024.
//

import Foundation
import UIKit

protocol CardViewModelDelegate: AnyObject {
    func setImage(img: UIImage)
}

class CardViewModel {
    
    //MARK: - Properties
    
    let user: User
    
    lazy var userInfoAttributedText: NSAttributedString = {
        let infoAttributedText = NSMutableAttributedString(string: self.user.name,
                                                           attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy),
                                                                        .foregroundColor: UIColor.white])
        
        infoAttributedText.append(NSAttributedString(string: "  \(self.user.age)",
                                                     attributes: [.font: UIFont.systemFont(ofSize: 24),
                                                                  .foregroundColor: UIColor.white]))
        return infoAttributedText
    }()
    
    let imageURLs: [String]
    var imageURL: URL?
    
    private var imageIndex = 0
    var index: Int {
        return imageIndex
    }
    
    weak var delegate: CardViewModelDelegate?
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        
        self.imageURLs = user.profileImageURLs
        self.imageURL = URL(string: self.imageURLs[0])
    }
    
    //MARK: - Methods
    
        func showNextPhoto() {
            guard imageIndex + 1 < user.profileImageURLs.count else {
                return
            }
    
            imageIndex += 1
            imageURL = URL(string: imageURLs[imageIndex])
        }
    
        func showPreviousPhoto() {
            guard imageIndex - 1 >= 0 else {
                return
            }
    
            imageIndex -= 1
            imageURL = URL(string: imageURLs[imageIndex])
        }
    
}
