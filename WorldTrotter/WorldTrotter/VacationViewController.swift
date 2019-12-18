//
//  VacationViewController.swift
//  WorldTrotter
//
//  Created by HaroldDavidson on 12/13/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit
import WebKit

class VacationViewController: UIViewController {
    let webView = WKWebView()
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://www.bignerdranch.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

}
