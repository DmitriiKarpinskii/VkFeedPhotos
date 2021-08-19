//
//  GreetViewController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 13.08.2021.
//

import UIKit

class WakeUpSessionViewController: UIViewController {
    
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let sceneDelegate = SceneDelegate.shared() else { return }
        authService = sceneDelegate.authService
        authService.wakeUpSession()
    }
}
