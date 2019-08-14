//
//  RZCartoonMineHeadView.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/14.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonMineHeadView: RZCartoonBaseView {

    lazy var img : UIImageView = {
        let img = UIImageView()
        let imgName = UserDefaults.standard.integer(forKey: sexTypeKey) == 1 ? "mine_bg_for_boy" : "mine_bg_for_girl"
        img.image = UIImage(named: imgName)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func initUI() {
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeSexTypeAction), name: NSNotification.Name(sexTypeKey), object: nil)
    
    }
    
    @objc func changeSexTypeAction() {
        let imgName = UserDefaults.standard.integer(forKey: sexTypeKey) == 1 ? "mine_bg_for_boy" : "mine_bg_for_girl"
        img.image = UIImage(named: imgName)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
