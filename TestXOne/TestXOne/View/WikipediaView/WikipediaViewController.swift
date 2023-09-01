//
//  WikipediaViewController.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import UIKit
import WebKit

class WikipediaViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: String = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
    }
    
}
