//
//  HeaderView.swift
//  appnavigation
//
//  Created by MACM72 on 24/02/26.
//

import UIKit

@IBDesignable
class HeaderView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButtonView: UIImageView!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        progressView.progress = 0.0
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.8)
    }
}
