//
//  NewsVC.swift
//  appnavigation
//
//  Created by MACM72 on 23/02/26.
//

import UIKit

class NewsVC: UIViewController {

    // 1. This is your stored reference (the child component)
    var webComponent: WebViewVC?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedWeb",
           let childVC = segue.destination as? WebViewVC {
            self.webComponent = childVC
            self.webComponent?.targetURL = "https://www.bbc.com/news"
        }
    }

}
