//
//  WebViewVC.swift
//  appnavigation
//
//  Created by MACM72 on 23/02/26.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    var targetURL: String? {
        didSet {
            if isViewLoaded {
                loadPage()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self
        loader.hidesWhenStopped = true

        loadPage()
    }

    deinit {
        // Prevent memory leaks
        webview.stopLoading()
        webview.navigationDelegate = nil
    }

    func loadPage() {
        guard let urlString = targetURL, let url = URL(string: urlString) else {
            print("WebViewVC: Waiting for valid URL...")
            return
        }

        let request = URLRequest(url: url)
        webview.load(request)
    }
}

extension WebViewVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loader.startAnimating()
        print("Web: Started loading...")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loader.stopAnimating()
        print("Web: Finished loading.")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loader.stopAnimating()
        print("Web Error: \(error.localizedDescription)")
    }
}
