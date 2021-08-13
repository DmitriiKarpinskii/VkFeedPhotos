//
//  SceneDelegate.swift
//  VkFeedPhotos
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//

import UIKit
import VKSdkFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {
  
  
    var window: UIWindow?
    var authService: AuthService!
    
    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sceneDelegate = (scene?.delegate as? SceneDelegate)!
        return sceneDelegate
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        authService = AuthService()
        authService.delegate = self
        
//        let authVC = AuthXViewController(nibName: "AuthXViewController", bundle: nil)
//        window?.rootViewController = authVC
//        window?.makeKeyAndVisible()
        
        let greetVC = WakeUpSessionViewController(nibName: "WakeUpSessionViewController", bundle: nil)
        window?.rootViewController = greetVC
        window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    //MARK: - AuthServiceDelegate
    
    func authServiceShouldShow(viewController: UIViewController) {
        print(#function)
        viewController.modalPresentationStyle = .automatic
//        window?.rootViewController?.present(viewController, animated: true, completion: nil)
        window?.rootViewController = viewController

    }
    
    func authServiceSignIn() {
        print(#function)
        let feedVC = PhotosFeedViewController(nibName: "PhotosFeedViewController", bundle: nil)
        let navVC = UINavigationController(rootViewController: feedVC)
        window?.rootViewController = navVC
    }
    
    func authServiceSignInDidFail() {
        print(#function)
    }
    
    func authServiceLogOut() {
        authService.logOut()
        let authVC = AuthXViewController(nibName: "AuthXViewController", bundle: nil)
        window?.rootViewController = authVC
    }
}

