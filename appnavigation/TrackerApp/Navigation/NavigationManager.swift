//
//  NavigationManager.swift
//  appnavigation
//
//  Created by MACM72 on 16/03/26.
//

import Foundation
import UIKit

struct NavigationManager {

    // MARK: - Segue Navigation
    static func navigate(via segue: AppDestination, from vc: UIViewController, sender: Any? = nil) {
        vc.performSegue(withIdentifier: segue.rawValue, sender: sender)
    }

    // MARK: - Programmatic Navigation
    static func pushProgrammatically(to destination: AppDestination, from vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: destination.storyboardID)

        if let navVp = vc.navigationController {
            navVp.pushViewController(targetVC, animated: true)
        } else {
            // Fallback if no navigation controller exists
            targetVC.modalPresentationStyle = .fullScreen
            vc.present(targetVC, animated: true)
        }
    }

    static func setRoot(to destination: AppDestination) {
            // Find the active window
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let targetVC = storyboard.instantiateViewController(withIdentifier: destination.storyboardID)

            // Wrap in a Navigation Controller so the Home screen can push to others
            let nav = UINavigationController(rootViewController: targetVC)

            // Swap the root with a smooth fade animation
            window.rootViewController = nav
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
}
