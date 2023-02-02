//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 08.01.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let userDefaults = UserDefaults.standard
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
