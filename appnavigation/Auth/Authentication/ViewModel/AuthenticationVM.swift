//
//  AuthenticationVM.swift
//  appnavigation
//
//  Created by MACM72 on 06/03/26.
//

import Foundation
import AuthenticationServices

protocol AuthenticationViewModelDelegate: AnyObject {
    func didLoginSuccessfully()
    func didFailLogin(with error: String)
}

class AuthenticationVM: NSObject {

    weak var delegate: AuthenticationViewModelDelegate?

    func startAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

     func handleAppleUser(userId: String, email: String?) {
        let defaults = UserDefaults.standard
        if let savedId = defaults.string(forKey: "apple_user_id"), savedId == userId {
            print("User already exists!")
        } else {
            defaults.set(userId, forKey: "apple_user_id")
            if let userEmail = email {
                defaults.set(userEmail, forKey: "user_email")
            }
        }

        delegate?.didLoginSuccessfully()
    }
}

// MARK: - Apple Auth Delegate
extension AuthenticationVM: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleUser(userId: appleIDCredential.user, email: appleIDCredential.email)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.didFailLogin(with: error.localizedDescription)
    }
}
