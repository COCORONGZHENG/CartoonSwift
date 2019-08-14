//
//  RZCartoonCateCollectionViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/29.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonCateCollectionViewCell: RZCartoonBaseCollectionViewCell {
    
    lazy var iconView : UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    lazy var title : UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.lightGray
        
        return title
    }()
    
    override func setUpUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubview(iconView)
        contentView.addSubview(title)
        
    }
    
    override func layoutSubviews() {
        iconView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
        }
        
    }
    
    var model : CartoonHopeModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.cover ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            title.text = model.sortName
        }
        
    }
    
}
