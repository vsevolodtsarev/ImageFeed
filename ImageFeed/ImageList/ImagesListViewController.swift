//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 17.11.2022.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageIdentifier = "ShowSingleImage"
    private var photoName = [String]()
    private var imagesListService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoName = Array(0..<20).map{ "\($0)" }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            if let indexPath = sender as? IndexPath {
                let image = UIImage(named: photoName[indexPath.row])
                viewController?.image = image
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with IndexPath: IndexPath) {
        guard let image = UIImage(named: photoName[IndexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = IndexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let photos = imagesListService.photos
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
}

