//
//  AlertViewController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 18.08.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ОК", style: .default)
        
        
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
}
