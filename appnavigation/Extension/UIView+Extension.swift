//
//  UIView+Extension.swift
//  appnavigation
//
//  Created by MACM72 on 03/03/26.
//
import UIKit
import ObjectiveC

private var tapKey: UInt8 = 0

extension UIView {

    typealias TapAction = () -> Void

    private var tapAction: TapAction? {
        get {
            return objc_getAssociatedObject(self, &tapKey) as? TapAction
        }
        set {
            objc_setAssociatedObject(self, &tapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addTapAction(action: @escaping TapAction) {
        isUserInteractionEnabled = true
        tapAction = action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        tapAction?()
    }

    func animateAppear() {

        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        UIView.animate(
            withDuration: 1,
            delay: 0.2,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 1
                self.transform = .identity
            },
            completion: nil
        )
    }

    // MARK: - Tap Animation
    func animateTap(completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: 0.1,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }) { _ in
            UIView.animate(withDuration: 0.15,
                           animations: {
                self.transform = .identity
            }) { _ in
                completion?()
            }
        }
    }
}
