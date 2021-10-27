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
    
    static func shared() -> SceneDelegate? {
        let scene = UIApplication.shared.connectedScenes.first
        guard let sceneDelegate = scene?.delegate as? SceneDelegate else { return nil }
        return sceneDelegate
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        authService = AuthService()
        authService.delegate = self
        
        let wakeUpVC = WakeUpSessionViewController(nibName: "WakeUpSessionViewController", bundle: nil)
        guard let window = window else { return }
        window.rootViewController = wakeUpVC
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    //MARK: - AuthServiceDelegate
    
    func authServiceShouldShow(viewController: UIViewController) {
        viewController.modalPresentationStyle = .automatic
        guard let window = window else { return }
        window.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print(#function)
        let feedVC = PhotosFeedViewController(nibName: "PhotosFeedViewController", bundle: nil)
        let navVC = NavigationController(rootViewController: feedVC)
        guard let window = window else { return }
        window.rootViewController = navVC
    }
    
    func authServiceSignInDidFail() {
        authServiceLogOut()
    }
    
    func authServiceLogOut() {
        print(#function)
        let authVC = AuthXViewController(nibName: "AuthXViewController", bundle: nil)
        guard let window = window else { return }
        window.rootViewController = authVC
        authService.logOut()
    }
    
    func authError(error: Error) {
        guard let window = window, let rootViewController = window.rootViewController else { return }
        rootViewController.showAlert(with: "Ошибка авторизации", message: error.localizedDescription)
        print(error.localizedDescription)
    }
    
}

