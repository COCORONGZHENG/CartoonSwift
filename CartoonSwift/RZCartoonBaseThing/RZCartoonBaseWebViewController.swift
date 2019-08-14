//
//  RZCartoonBaseWebViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/29.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import WebKit
class RZCartoonBaseWebViewController: RZCartoonBaseViewController {

    lazy var webView : WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    lazy var progress : UIProgressView = {
        let progress = UIProgressView()
        progress.trackImage = UIImage(named: "nav_bg")
        progress.progressTintColor = UIColor.white
        return progress
    }()
    
    var request : URLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        webView.load(request)
        
    }

    convenience init(url:String?) {
        self.init()
        
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.isHidden = webView.estimatedProgress >= 1.0
            progress.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
    }
    
    
    override func initUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(progress)
        progress.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    override func configNavieBar() {
        super.configNavieBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"), style: .plain, target: self, action: #selector(reloadAction))
        
    }
    
    @objc func reloadAction() {
        webView.reload()
    }
    
    override func pressBackItem() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)

        }
        
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
    }
}
