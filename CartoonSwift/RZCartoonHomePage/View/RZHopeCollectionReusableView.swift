//
//  RZHopeCollectionReusableView.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/26.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import RxCocoa
typealias HopeMoreActionBlock = () -> Void
class RZHopeCollectionReusableView: RZBaseCollectionReusableView {
    
    var moreActionBlock : HopeMoreActionBlock?
    
    lazy var iconView : UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    lazy var moreButton : UIButton = {
        let moreButton = UIButton(type: .custom)
        moreButton.setTitle("•••", for: .normal)
        moreButton.setTitleColor(.lightGray, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        _ = moreButton.rx.tap.subscribe({ (event) in
            guard let block = self.moreActionBlock else {return}
            block()
        })
        return moreButton
    }()
    
    func moreActionBlock(_ moreActionBlock : HopeMoreActionBlock?) {
        self.moreActionBlock = moreActionBlock
    }
    
    var model : CartoonHopeModel? {
        didSet {
            
            guard let model = model  else {return}
            iconView.kf.setImage(with: URL(string: model.newTitleIconUrl ?? ""))
            titleLabel.text = model.itemTitle
            
        }
        
    }
    
    
    
    override func initUI() {
        backgroundColor = .white
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(5)
            make.centerY.height.equalTo(iconView)
            make.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
    
}
