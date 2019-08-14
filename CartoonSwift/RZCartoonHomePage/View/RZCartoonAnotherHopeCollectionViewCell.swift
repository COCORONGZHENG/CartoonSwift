//
//  RZCartoonAnotherHopeCollectionViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/26.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonAnotherHopeCollectionViewCell: RZCartoonBaseCollectionViewCell {
    
    // 布局
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override func setUpUI() {
        super.setUpUI()
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
        }
    }
    
    var model : CartoonItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.cover ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
        }
        
    }
    
}
