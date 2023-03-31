//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 14.12.2022.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var fullImageURL: URL?
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak private var backButton: UIButton!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.isAccessibilityElement = true
        backButton.accessibilityIdentifier = "Back button"
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setFullImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
        
    //MARK: private func
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        let activityImage = [imageView.image]
        let activityAction = UIActivityViewController(activityItems: activityImage as [Any], applicationActivities: nil)
        present(activityAction, animated: true)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setFullImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                print(error)
                self.showError()
                
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать еще раз?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Не надо",
            style: .default))
        alert.addAction(UIAlertAction(
            title: "Повторить",
            style: .default,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.setFullImage()
            }))
        self.present(alert, animated: true)
    }
    
}
// MARK: Extensions
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
