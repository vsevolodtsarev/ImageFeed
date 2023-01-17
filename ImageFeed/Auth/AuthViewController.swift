//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 03.01.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    private let unsplashAuthScreenSegueId = "ShowWebView"
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == unsplashAuthScreenSegueId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(unsplashAuthScreenSegueId)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                    self.oAuth2TokenStorage.token = token
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

