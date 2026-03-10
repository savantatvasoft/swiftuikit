//
//  AuthenticationVC.swift
//  appnavigation
//
//  Created by MACM72 on 02/03/26.
//

import UIKit
import AuthenticationServices

class AuthenticationVC: UIViewController, KeyboardHandler {

    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var googleLoginView: UIView!
    @IBOutlet weak var emailBox: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submitView: UIView!

    private let viewModel = AuthenticationVM()
    private var hasAnimated = false

    var keyboardOverlapPadding: CGFloat { return 50.0 }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        setupKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        cusotmActionListener()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasAnimated {
            appleLoginView.animateAppear()
            googleLoginView.animateAppear()
            submitView.animateAppear()
            hasAnimated = true
        }

    }

    func setupUI() {
        emailBox.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        emailBox.layer.borderWidth = 1
        emailBox.layer.cornerRadius = 24

        let placeholderText = "Enter your email"
        let customFont = UIFont(name: "GillSans", size: 16) ?? UIFont.systemFont(ofSize: 16)

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.6),
            .font: customFont
        ]

        email.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        email.textColor = .white
        email.font = customFont
    }

    func cusotmActionListener() {
        appleLoginView.addTapAction { [weak self] in
            self?.appleLoginView.animateTap {
                self?.viewModel.startAppleLogin()
            }
        }

        googleLoginView.addTapAction { [weak self] in
            self?.googleLoginView.animateTap {
                print("Google Login tapped")
                if let secondVC = self?.storyboard?.instantiateViewController(withIdentifier: "DynamicHeightVCID") {
                    self?.navigationController?.pushViewController(secondVC, animated: true)
                }
            }
        }

        submitView.addTapAction { [weak self] in
            self?.submitView.animateTap {
                print("submitView")
            }
        }
    }
}

extension AuthenticationVC: AuthenticationViewModelDelegate {

    func didLoginSuccessfully() {
        print("Navigation to Home screen...")
    }

    func didFailLogin(with error: String) {
        print("Error: \(error)")
    }
}

extension AuthenticationVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
