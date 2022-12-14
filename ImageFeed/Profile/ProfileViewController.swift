//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 08.12.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
    
    // MARK: ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        addSubviews()
        addConstraints()
    }
    
    // MARK: private func
    
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
    
    @objc private func didTapButton() {
        
    }
}
