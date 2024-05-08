//
//  ProfileSettingsViewModel.swift
//  CinephileDatingApp
//
//  Created by Ilya on 24.04.2024.
//

import Foundation


enum SettingsSections: Int, CaseIterable {
    case name
    case age
    case bio
    case favoriteFilms
    case ageRange
    
    var description: String {
        switch self {
        case .name: return "Имя"
        case .age: return "Возраст"
        case .bio: return "О себе"
        case .favoriteFilms: return "Любимые фильмы"
        case .ageRange: return "Определите желаемый возраст собеседника"
        }
    }
}

struct ProfileSettingsViewModel {
    private let user: User
    let section: SettingsSections
    let placeholderText: String
    var value: String?
    
    var shouldHideInpurField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Мин: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Макс: \(Int(value))"
    }
    
    init(user: User, section: SettingsSections) {
        self.user = user
        self.section = section
        
        placeholderText = "Введите \(section.description.lowercased())"
        
        switch section {
        case .name:
            value = user.name
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .favoriteFilms:
            value = ""
        case .ageRange:
            break
        }
    }
}
