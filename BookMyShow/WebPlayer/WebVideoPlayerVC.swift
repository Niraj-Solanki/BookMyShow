//
//  WebVideoPlayerVC.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 11/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
import WebKit

class WebVideoPlayerVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK:- Objects
    var videoUrl:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = videoUrl {
            webView.load(URLRequest(url: url))
        }
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

