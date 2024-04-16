//
//  CardViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 15.04.2024.
//

import Foundation
import UIKit

protocol CardViewModelDelegate {
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
    
    private var imageIndex = 0
    
    var delegate: CardViewModelDelegate?
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
    }
    
    //MARK: - Methods
    
    func showNextPhoto() {
        guard imageIndex + 1 < user.images.count else {
            return
        }
        
        imageIndex += 1
        let img = user.images[imageIndex]
        self.delegate?.setImage(img: img)
    }
    
    func showPreviousPhoto() {
        guard imageIndex - 1 >= 0 else {
            return
        }
        
        imageIndex -= 1
        let img = user.images[imageIndex]
        self.delegate?.setImage(img: img)
    }
}
