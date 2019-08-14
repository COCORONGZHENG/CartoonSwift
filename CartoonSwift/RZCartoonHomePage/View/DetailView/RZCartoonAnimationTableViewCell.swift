//
//  RZCartoonAnimationTableViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/5.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonAnimationTableViewCell: RZCartoonBaseTableViewCell {

    lazy var titile : UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        
        return title
    }()
    
    lazy var iconView : UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 4
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var descLabel : UILabel = {
        let descLab = UILabel()
        descLab.textColor = .white
        descLab.font = UIFont.systemFont(ofSize: 11)
        descLab.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return descLab
    }()
    
    
    override func initUI() {
        contentView.addSubview(titile)
        titile.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(15)
            make.right.equalTo(-10)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titile)
            make.bottom.equalTo(-20)
            make.top.equalTo(titile.snp.bottom).offset(10)
        }
        
        iconView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let interval = UIView()
        interval.backgroundColor = UIColor.bg_color
        contentView.addSubview(interval)
        interval.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(10)
        }
        
        
    }
    
    var model : CartoonCateDetailItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            titile.text = model.title ?? model.name
            descLabel.text = model.subTitle ?? model.description
            iconView.kf.setImage(with: URL(string: model.cover ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            
            
            
        }
        
    }

}
