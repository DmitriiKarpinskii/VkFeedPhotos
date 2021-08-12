//
//  AuthSevice.swift
//  VkPhotosFeed
//
//  Created by Dmitry Karpinsky on 04.08.2021.
//

import Foundation
import VKSdkFramework


protocol AuthServiceDelegate: class {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appID = "7918637"
    private let vkSdk : VKSdk
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appID)
        super.init()
        print("VKSDk initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    weak var delegate : AuthServiceDelegate?
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    func wakeUpSession() {
        let scope = ["offline"]
//        let scope = ["wall, friends"]
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()

            default:
                delegate?.authServiceSignInDidFail()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
    
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
