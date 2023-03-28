//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 28.03.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    private let imagesListServiceNotification = ImagesListService.didChangeNotification
    private let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: imagesListServiceNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.updateTableViewAnimated()
                }
        view?.updateTableViewAnimated()
    }
    
    
}
