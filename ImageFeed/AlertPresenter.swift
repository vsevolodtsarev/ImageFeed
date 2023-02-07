//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 07.02.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}

struct AlertPresenter {
    weak var present: UIViewController?
    func showResult(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText,
                                   style: .default,
                                   handler: alertModel.completion)
        alert.addAction(action)
        present?.present(alert, animated: true, completion: nil)
    }
}


