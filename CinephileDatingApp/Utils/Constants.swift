//
//  Constraints.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.04.2024.
//

import Foundation
import UIKit
import Firebase


struct Constants {
    
    enum Fonts: String {
        case Montserrat
        
        var bold: String {
            return self.rawValue + "-Bold"
        }
        
        var medium: String {
            return self.rawValue + "-Medium"
        }
    }
    
    struct Colors {
        static let customBlack = #colorLiteral(red: 0.1206690893, green: 0.1256528199, blue: 0.1341503859, alpha: 1)
        static let barDeselect = UIColor(white: 0, alpha: 0.1)
    }
    
    struct Firebase {
        static let COLLECTION_USERS = Firestore.firestore().collection("users")
        static let COLLECTION_SWIPES = Firestore.firestore().collection("swipes")
        static let COLLECTION_MATCHES_MESSAGES = Firestore.firestore().collection("matches_messages")
    }
}
