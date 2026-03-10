//
//  KeyboardHandler+Extension.swift
//  appnavigation
//
//  Created by MACM72 on 03/03/26.
//

import Foundation
import UIKit

protocol KeyboardHandler: AnyObject {
    var scrollView: UIScrollView! { get }
    var keyboardOverlapPadding: CGFloat { get }
    func setupKeyboardNotifications()
    func hideKeyboardWhenTappedAround()
}

extension KeyboardHandler where Self: UIViewController {

    var keyboardOverlapPadding: CGFloat { return 20.0 }

    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            self?.handleKeyboard(notification: notification, isShowing: true)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            self?.handleKeyboard(notification: notification, isShowing: false)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func handleKeyboard(notification: Notification, isShowing: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let bottomPadding = isShowing ? (keyboardFrame.height - view.safeAreaInsets.bottom + keyboardOverlapPadding) : 0
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)

        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }

        if isShowing, let activeField = UIResponder.currentFirst() as? UIView {
            let rect = activeField.convert(activeField.bounds, to: self.scrollView)
            var targetRect = rect
            targetRect.size.height += keyboardOverlapPadding

            self.scrollView.scrollRectToVisible(targetRect, animated: true)
        }
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIResponder {
    private static weak var _currentFirstResponder: UIResponder?

    static func currentFirst() -> UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._findFirstResponder(_:)), to: nil, from: nil, for: nil)
        print("_currentFirstResponder : \(_currentFirstResponder)")
        return _currentFirstResponder
    }

    @objc private func _findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
