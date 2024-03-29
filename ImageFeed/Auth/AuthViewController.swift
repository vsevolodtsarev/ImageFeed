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
    
    @IBOutlet  weak private var authButton: UIButton!
    private let unsplashAuthScreenSegueId = "ShowWebView"
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let oAuth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authButton.isAccessibilityElement = true
        authButton.accessibilityIdentifier = "Authenticate"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == unsplashAuthScreenSegueId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(unsplashAuthScreenSegueId)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
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
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
}

