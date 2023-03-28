//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 05.02.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.configure(imagesListPresenter)
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("", comment: ""),
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.configure(profilePresenter)
        
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("", comment: ""),
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
