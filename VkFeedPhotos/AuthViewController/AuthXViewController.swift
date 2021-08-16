//
//  AuthXViewController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 05.08.2021.
//

import UIKit

class AuthXViewController: UIViewController {
    
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
    }

    @IBAction func signInTouch(_ sender: Any) {
        authService.autorized()
    }
}
