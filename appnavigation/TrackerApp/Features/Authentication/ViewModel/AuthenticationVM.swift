//
//  AuthenticationVM.swift
//  appnavigation
//
//  Created by MACM72 on 06/03/26.
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

protocol AuthenticationViewModelDelegate: AnyObject {
    func didLoginSuccessfully()
    func didFailLogin(with error: String)
}

class AuthenticationVM: NSObject {

    var isLoading: Bool = false

    @objc dynamic var emailText: String = ""

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


extension AuthenticationVM {

    func signInWithGoogle(presentingVC: UIViewController) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Firebase Client ID not found"])
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)

        let user = signInResult.user
        print("Google User: \(user.profile?.name ?? "No Name") (\(user.profile?.email ?? "No Email"))")

        guard let idToken = user.idToken?.tokenString else {
            throw NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Google ID Token missing"])
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)

        print("--- 🟡 Exchanging for Firebase Session ---")
        let authResult = try await Auth.auth().signIn(with: credential)
        print("--- 🔵 Firebase Login Success ---")
        print("Firebase UID: \(authResult.user.uid)")
        print("Firebase Email: \(authResult.user.email ?? "N/A")")
    }
}
