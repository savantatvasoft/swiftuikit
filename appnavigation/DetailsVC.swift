//
//  DetailsVC.swift
//  appnavigation
//
//  Created by MACM72 on 27/01/26.
//

import UIKit

class DetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailsVC → viewDidLoad")

        view.backgroundColor = .systemOrange
        title = "Details"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DetailsVC → viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DetailsVC → viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DetailsVC → viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("DetailsVC → viewDidDisappear")
    }

    deinit {
        print("DetailsVC → deinit")
    }
}
