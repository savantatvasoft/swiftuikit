//
//  AnimatedPressableInsideView.swift
//  appnavigation
//
//  Created by MACM72 on 25/02/26.
//

import UIKit

class AnimatedPressableInsideView: UIView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(scale: 0.95, alpha: 0.8)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(scale: 1.0, alpha: 1.0)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(scale: 1.0, alpha: 1.0)
    }

    private func animate(scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.alpha = alpha
        })
    }
}
