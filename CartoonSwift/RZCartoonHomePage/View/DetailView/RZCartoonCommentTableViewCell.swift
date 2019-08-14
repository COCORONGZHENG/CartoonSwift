//
//  RZCartoonCommentTableViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/31.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonCommentTableViewCell: RZCartoonBaseTableViewCell {

    lazy var icon : UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
        return iconView
    }()
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.gray
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        return nickNameLabel
    }()
    lazy var contentTextView: UILabel = {
        let contentTextView = UILabel()
        contentTextView.numberOfLines = 0
        contentTextView.font = UIFont.systemFont(ofSize: 13)
        contentTextView.textColor = UIColor.black
        return contentTextView
    }()
    
    override func initUI() {
        contentView.addSubview(icon)
        icon.snp.makeConstraints{ make in
            make.left.top.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(icon)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(15)
        }
        
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(nickNameLabel)
            make.bottom.equalTo(-10)
        }
    }
    
    var model : CartoonCommentModel? {
        didSet {
            guard let model = model else {
                return
            }
            icon.kf.setImage(with: URL(string: model.face ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            nickNameLabel.text = model.nickname
            contentTextView.text = model.content_filter
            
        }
        
    }
    

}
