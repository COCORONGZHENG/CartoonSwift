//
//  RZCartoonBaseViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = .white
        initUI()
        configNavieBar()
    }
    
    func initUI()  {}
    
    func configNavieBar() {
        guard let naviBar = navigationController else {
            return
        }
        if naviBar.visibleViewController == self {
            naviBar.naviBarStyle(.green)
            if naviBar.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"), style: .plain, target: self, action: #selector(pressBackItem))
                navigationItem.leftBarButtonItem?.tintColor = .white

            }
        }
    }
    
    @objc func pressBackItem ()  {
        navigationController?.popViewController(animated: true)
    }
    
}




extension RZCartoonBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
}
