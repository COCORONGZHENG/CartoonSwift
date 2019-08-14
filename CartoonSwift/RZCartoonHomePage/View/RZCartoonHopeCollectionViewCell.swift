//
//  RZCartoonHopeCollectionViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

enum CartoonHopeCollectionViewCellType {
    case withNone
    case withTitle
    case withTitleAndSubTitle
}

class RZCartoonHopeCollectionViewCell: RZCartoonBaseCollectionViewCell {
    
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
        return titleLabel
    }()
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.gray
        descLabel.font = UIFont.systemFont(ofSize: 12)
        return descLabel
    }()
    override func setUpUI() {
        super.setUpUI()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
    }
    
    var model : CartoonItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.cover ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name ?? model.title
            descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")集"
        }
        
    }
    
    var guessLikeModel : CartoonGuessLikeModel? {
        didSet {
            guard let model = guessLikeModel else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.cover ?? ""))
            titleLabel.text = model.name
            
        }
    }
    
    var otherProductModel : CartoonDetailStaticModel? {
        didSet {
            guard let model = otherProductModel else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.coverUrl ?? ""),placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            descLabel.text = "跟新至第\(model.passChapterNum)集"
            
        }
        
    }
    
    
    
    var cellType : CartoonHopeCollectionViewCellType = .withTitle  {
        didSet {
            switch cellType {
            case .withNone:
                // 布局更新
                titleLabel.snp.updateConstraints{ make in
                    make.bottom.equalToSuperview().offset(25)
                }
                titleLabel.isHidden = true
                descLabel.isHidden = true
                break
                
            case .withTitle:
                titleLabel.snp.updateConstraints{ make in
                    make.bottom.equalToSuperview().offset(-10)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = true
                
                break
                
            case .withTitleAndSubTitle:
                titleLabel.snp.updateConstraints{ make in
                    make.bottom.equalToSuperview().offset(-25)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = false
                break
                
            }
        }
    }
}


