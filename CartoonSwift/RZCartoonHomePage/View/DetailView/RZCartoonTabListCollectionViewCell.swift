//
//  RZCartoonTabListCollectionViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/31.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import RxSwift
class RZCartoonTabListCollectionViewCell: RZCartoonBaseCollectionViewCell {
    lazy var titleLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    
    override func setUpUI() {
        layer.cornerRadius = 3
        layer.borderColor = UIColor.bg_color.cgColor
        layer.borderWidth = 1.0

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }
    
    var model : CartoonChapterStaticModel? {
        didSet {
            guard let model = model else {
                return
            }
            titleLabel.text = model.name
        }
        
    }
    
}


typealias CartoonSortActionBlock = (_ btn : UIButton?) -> Void

class RZCartoonTabListTableHead : RZBaseCollectionReusableView {
    
    var sortBlock : CartoonSortActionBlock?
    lazy var descLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.gray
        lab.font = UIFont.systemFont(ofSize: 13)
        
        return lab
    }()
    lazy var sortBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("倒序", for: .normal)
        btn.setTitle("正序", for: .selected)
        btn.isSelected = false
        btn.setTitleColor(.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        _ = btn.rx.tap.subscribe({ (event) in
            guard let block = self.sortBlock else {return}
            btn.isSelected = !btn.isSelected
            block(btn)
        })
        return btn
    }()
    
    override func initUI() {
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-50)
        }
        addSubview(sortBtn)
        sortBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.width.equalTo(45)
        }
    }
    
    func sortBlock(_ sortBlock : CartoonSortActionBlock?) {
        self.sortBlock = sortBlock
    }
    
    var model : CartoonHopeBaseModel?{
        didSet {
            guard let model = model else {
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyy-MM-dd"
            descLabel.text = "目录 \(formatter.string(from: Date(timeIntervalSince1970: model.comic?.last_update_time ?? 0))) 跟新 \(model.chapter_list?.last?.name ?? "")"
            
        }
    }
}
