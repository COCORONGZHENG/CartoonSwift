//
//  RZCartoonSearchHeadView.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/12.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import RxSwift

typealias CartoonSearchSectionHeadBlock = (_ sender : UIButton) -> Void
class RZCartoonSearchHeadView: RZCartoonSectionSpaceView {

    var searchHeadBlock : CartoonSearchSectionHeadBlock?
    
    lazy var descLab : UILabel = {
        let descLab = UILabel()
        descLab.textColor = UIColor.lightGray
        descLab.font = UIFont.systemFont(ofSize: 12)
        return descLab
    }()
    
    lazy var btn : UIButton = {
        let btn = UIButton(type: .custom)
        _ = btn.rx.tap.subscribe({ (event) in
            guard let block = self.searchHeadBlock else {return}
            block(btn)
        })
        
        return btn
    }()
    
    func cartoonSearchSectionHeadBlock(_ block : @escaping CartoonSearchSectionHeadBlock)  {
        self.searchHeadBlock = block
    }
    
    override func initUI() {
        
        addSubview(descLab)
        descLab.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
        }
        
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(40)
        }
        
        
    }

}
