//
//  RZCartoonSortListTableViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/28.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonSortListTableViewCell: RZCartoonBaseTableViewCell {

    lazy var iconImg : UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true // icon 可以裁剪防止图片超出约束距离
        return icon
    }()
    
    lazy var title : UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = .black
        return title
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.gray
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 14)
        return descLabel
    }()
    
    override func initUI() {
        
        let line = UILabel()
        line.backgroundColor = UIColor.bg_color
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
        
        contentView.addSubview(iconImg)
        
        contentView.addSubview(title)
        
        contentView.addSubview(descLabel)
        iconImg.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(0.5 * kScreenWidth)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(iconImg.snp.right).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(iconImg.snp.height).multipliedBy(0.5)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(title)
            make.top.equalTo(title.snp.bottom)
            make.bottom.equalTo(-10)
        }
    }
    
    override func layoutSubviews() {
        
        
    }
    
    
    var model : CartoonHopeModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconImg.kf.setImage(with: URL(string: model.cover ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            title.text = model.title
            descLabel.text = model.subTitle
            
        }
    }
    
    
}
