//
//  RZCartoonCateDetailTableViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/2.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonCateDetailTableViewCell: RZCartoonBaseTableViewCell {

    var spinnerName : String?
    lazy var iconView : UIImageView = {
        let iconView = UIImageView()
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    lazy var subTitle : UILabel = {
        let subTitle = UILabel()
        subTitle.font = UIFont.systemFont(ofSize: 12)
        subTitle.textColor = .lightGray
        return subTitle
    }()
    lazy var descLabel : UILabel = {
        let descLabel = UILabel()
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = .lightGray
        return descLabel
    }()
    lazy var logoImg : UIImageView = {
        let logoImg = UIImageView()
        logoImg.contentMode = .scaleAspectFill
//        logoImg.isHighlighted = true
        return logoImg
    }()
    
    lazy var updateLabel : UILabel = {
        let updateLabel = UILabel()
        updateLabel.font = UIFont.systemFont(ofSize: 12)
        updateLabel.textColor = UIColor.orange
        return updateLabel
    }()
    
    
    override func initUI() {
    
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.top)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(16)
            
        }
        
        contentView.addSubview(logoImg)
        logoImg.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-10)
            make.width.height.equalTo(20)
            
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(logoImg.snp.top).offset(-10)
            make.top.equalTo(subTitle.snp.bottom).offset(20)
        }
        
        contentView.addSubview(updateLabel)
        updateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.bottom.top.equalTo(logoImg)
            make.right.equalTo(logoImg.snp.left).offset(-10)
        }
        
        
    }

    var model : CartoonCateDetailItemModel? {
        didSet {
            guard let model = model else {
                return
            }
//            normal_placeholder_v
            iconView.kf.setImage(with: URL(string: model.cover ?? "") ,placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            subTitle.text = "\(model.tags?.joined(separator: "") ?? "") | \(model.author ?? "")"
            descLabel.text = model.description
        
            if spinnerName == "更新时间" {
                let updateStr = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(model.conTag)))
                var tipstr = ""
                if updateStr < 60 {
                    tipstr = "\(Int(updateStr))秒前"
                } else if updateStr < 3600 {
                    tipstr = "\(Int(updateStr) / 60)分钟前"
                } else if updateStr < 86400 {
                    tipstr = "\(Int(updateStr) / 3600)小时前"
                } else if updateStr < 31536000{
                    tipstr = "\(Int(updateStr) / 86400)天前"
                } else {
                    tipstr = "\(Int(updateStr) / 31536000)年前"
                }
                let text = spinnerName! + " : " + tipstr
                updateLabel.text = text
                logoImg.isHidden = true
            } else {
                var tipstr = ""
                if model.conTag > 100000000 {
                    tipstr = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                } else if model.conTag > 10000 {
                    tipstr = String(format: "%.1f万", Double(model.conTag) / 10000)
                } else {
                    tipstr = "\(model.conTag)"
                }
                if tipstr != "0" { updateLabel.text = "\(spinnerName ?? "总点击")" + tipstr }
                logoImg.isHidden = false
                
            }

         }
    }
    
    var indexpath : IndexPath? {
        didSet {
            guard let indexpath = indexpath else {
                return
            }
            switch indexpath.row {
            case 0:
                logoImg.image = UIImage(named: "rank_frist")
                break
            case 1:
                logoImg.image = UIImage(named: "rank_second")
                break
            case 2:
                logoImg.image = UIImage(named: "rank_third")
                break
            default:
                logoImg.image = nil
                break
            }
        }
    }
}
