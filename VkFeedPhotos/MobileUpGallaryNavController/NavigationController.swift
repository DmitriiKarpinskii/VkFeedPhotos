//
//  NavigationController.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 13.08.2021.
//

import Foundation
import UIKit

class NavigationController : UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }
        
        return .default
    }
}
