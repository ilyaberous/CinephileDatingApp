//
//  Constraints.swift
//  CinephileDatingApp
//
//  Created by Ilya on 20.04.2024.
//

import Foundation
import UIKit


struct Constraints {
    
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
    }
}
