//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 08.12.2022.
//

import UIKit
import Kingfisher


class ProfileViewController: UIViewController {
    
    private let profileImageServiceNotification = ProfileImageService.didChangeNotification
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var profileImage: UIImageView = {
        let image = UIImage(named: "Photo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        return nameLabel
    }()
    
    private var nicknameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "@ekaterina_nov"
        nickNameLabel.textColor = UIColor(named: "YP Grey")
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        return nickNameLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()
    
    private var exitButton: UIButton = {
        let exitButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        let exitButton = UIButton.systemButton(with: exitButtonImage!,
                                               target: nil,
                                               action: #selector(didTapButton))
        exitButton.tintColor = UIColor(named: "YP Red")
        return exitButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateAvatar()
        view.backgroundColor = UIColor(named: "YP Black")
        
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
        
        addSubviews()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: profileImageServiceNotification,
                         object: nil,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: profileImageServiceObserver as? NSNotification.Name, object: nil)
    }
    
    // MARK: private func
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImage.kf.setImage(with: url,
                                 placeholder: UIImage(named: "person.crop.circle.fill"),
                                 options: [.processor(processor)])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func addConstraints() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8).isActive = true
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8).isActive = true
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
    }
    
    private func addSubviews() {
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }
    
    private func logOut() {
        OAuth2TokenStorage.clean()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Да",
            style: .default,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.logOut()
            }))
        alert.addAction(UIAlertAction(
            title: "Нет",
            style: .default))
        self.present(alert, animated: true)
    }
}
