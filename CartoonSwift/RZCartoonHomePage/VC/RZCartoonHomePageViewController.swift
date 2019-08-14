//
//  RZCartoonHomePageViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonHomePageViewController: RZCartoonPageControlViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchItemAction(searchItem:)))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    @objc func searchItemAction(searchItem : UIBarButtonItem) {
        
        navigationController?.pushViewController(RZCartoonSearchHomeViewController(), animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.naviBarStyle(.green)
        
    }
    
    
    
    

}
