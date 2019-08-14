//
//  RZCartoonDetailHeaderView.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/30.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonDetailHeaderView: RZCartoonBaseView {

    private var tipList : [String]?
    private var blurView : UIView!
    
    private lazy var bgView : UIImageView = {
        let bgView = UIImageView()
        bgView.clipsToBounds = true
        bgView.contentMode = .scaleAspectFill
        
        return bgView
    }()
    
    private lazy var coverView: UIImageView = {
        let coverView = UIImageView()
        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 3
        coverView.layer.borderWidth = 1
        coverView.layer.borderColor = UIColor.white.cgColor
        return coverView
    }()
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        return nameLabel
    }()
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = UIColor.white
        authorLabel.font = UIFont.systemFont(ofSize: 13)
        return authorLabel
    }()
    
    private lazy var totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.textColor = UIColor.white
        totalLabel.font = UIFont.systemFont(ofSize: 13)
        return totalLabel
    }()
    
    private lazy var collect : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 40, height: 20)
        layout.scrollDirection = .horizontal
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.backgroundColor = .clear
        collect.delegate = self
        collect.dataSource = self
        collect.register(RZCartoonDetailBtnCollectViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonDetailBtnCollectViewCell")
        return collect
    }()
    
    
    override func initUI() {
        
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        bgView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        bgView.addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.left.equalTo(20)
            make.width.equalTo(90)
            make.height.equalTo(120)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverView.snp.right).offset(20)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.top.equalTo(coverView)
            make.height.equalTo(20)
        }
        bgView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.left.height.equalTo(nameLabel)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        bgView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.left.height.equalTo(authorLabel)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
        }
        
        bgView.addSubview(collect)
        collect.snp.makeConstraints { make in
            make.left.equalTo(totalLabel)
            make.height.equalTo(30)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.bottom.equalTo(coverView)
        }
        
    }
    
    var model : CartoonComicStaticModel? {
        didSet {
            guard let detailStatic = model else {return}
            bgView.kf.setImage(with: URL(string: detailStatic.cover ?? ""), placeholder: UIImage(named: "normal_placeholder_v"))
            coverView.kf.setImage(with: URL(string: detailStatic.cover ?? ""), placeholder: UIImage(named: "normal_placeholder_v"))
            nameLabel.text = detailStatic.name
            authorLabel.text = detailStatic.author?.name
            tipList = detailStatic.theme_ids ?? []
            collect.reloadData()
            
        }
        
    }
    
    var realTimemodel : CartoonComicRealtimeModel? {
        didSet {
            guard let detailRealtime = realTimemodel else {
                return
            }
            let text = NSMutableAttributedString(string: "点击 收藏")
            
            text.insert(NSAttributedString(string: " \(detailRealtime.click_total ?? "0") ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]), at: 2)
            
            text.append(NSAttributedString(string: " \(detailRealtime.favorite_total ?? "0") ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
            totalLabel.attributedText = text
            
            
        }
        
    }

}

extension RZCartoonDetailHeaderView : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tipList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonDetailBtnCollectViewCell", for: indexPath) as! RZCartoonDetailBtnCollectViewCell
        cell.tip = self.tipList?[indexPath.item]
        return cell
    }
    
}


class RZCartoonDetailBtnCollectViewCell: RZCartoonBaseCollectionViewCell {
    private lazy var tipLab : UILabel = {
        let tipLab = UILabel()
        tipLab.textColor = UIColor.white
        tipLab.textAlignment = .center
        tipLab.font = UIFont.systemFont(ofSize: 14)
        return tipLab
    }()
    
    
    override func setUpUI() {
        layer.cornerRadius = 3
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        contentView.addSubview(tipLab)
        tipLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    var tip : String?  {
        
        didSet {
            guard let tipMsg = tip else{return}
            tipLab.text = tipMsg
        }
        
    }
    
    
}
