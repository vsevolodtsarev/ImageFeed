//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 20.11.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    static let reuseIdentifier = "ImagesListCell"
}
