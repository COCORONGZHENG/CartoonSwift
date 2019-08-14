//
//  RZBaseCollectionReusableView.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/26.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import RxCocoa
class RZBaseCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {

    }
    
    
}
