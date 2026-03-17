//
//  UIViewController.swift
//  appnavigation
//
//  Created by MACM72 on 17/03/26.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String = "Error", message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
