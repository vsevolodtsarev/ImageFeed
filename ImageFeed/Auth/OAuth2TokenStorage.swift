//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 08.01.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let keyChain = KeychainWrapper.standard
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            keyChain.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            guard let newValue = newValue else { return }
            keyChain.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
