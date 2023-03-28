//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 28.03.2023.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageServiceNotification = ProfileImageService.didChangeNotification
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: profileImageServiceNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.updateAvatar()
                }
        view?.updateAvatar()
    }    
}
