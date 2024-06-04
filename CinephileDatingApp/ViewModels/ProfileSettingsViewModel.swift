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
    var placeholderText: String = ""
    var value: String?
    
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
        
        switch section {
        case .name:
            value = user.name
            placeholderText = "Введите свое \(section.description.lowercased())"
        case .age:
            value = "\(user.age)"
            placeholderText = "Введите свой \(section.description.lowercased())"
        case .bio:
            value = user.bio
            placeholderText = "Расскажите \(section.description.lowercased())"
        case .favoriteFilms, .ageRange:
            break
        }
    }
}
