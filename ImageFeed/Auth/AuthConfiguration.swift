//
//  Constants.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 26.12.2022.
//

import UIKit

let AccessKey = "Ti3z6SHJ0S4xY2aa7rH6HEKfliOmIZ5GazD6uw4Wf9A"
let SecretKey = "bGFpNMGUeXv9P0Xqeue-qk_vUgm9GkFBofQWPfhaVQk"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey, secretKey: SecretKey, redirectURI: RedirectURI, accessScope: AccessScope, defaultBaseURL: DefaultBaseURL, authURLString: UnsplashAuthorizeURLString)
    }
}
