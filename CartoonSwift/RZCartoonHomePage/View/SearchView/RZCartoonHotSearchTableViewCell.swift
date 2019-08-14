//
//  RZCartoonHotSearchTableViewCell.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/13.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonHotSearchTableViewCell: RZCartoonBaseTableViewCell{

    
    lazy var collect : UICollectionView = {
        let layout = UCollectionViewAlignedLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.horizontalAlignment = .left
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.backgroundColor = UIColor.white
        collect.delegate = self
        collect.dataSource = self
        collect.register(RZCartoonHotSearchItemCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonHotSearchItemCell")
        return collect
    }()
    
    override func initUI() {
        
        contentView.addSubview(collect)
        collect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var dataArray : NSArray? {
        didSet {
            collect.reloadData()
        }
        
    }
}

extension RZCartoonHotSearchTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonHotSearchItemCell", for: indexPath) as! RZCartoonHotSearchItemCell
        cell.model = self.dataArray?[indexPath.item] as? CartoonSearchHotItemModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArray?[indexPath.item] as? CartoonSearchHotItemModel
            let vc = RZCartoonTool.getControllerfromview(view: self)
        vc?.navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: model?.comic_id), animated: true)

        
    }
    
}





class RZCartoonHotSearchItemCell: RZCartoonBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.darkGray
        return titleLabel
    }()
    
    override func setUpUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.bg_color.cgColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)) }
    }
    
    var model : CartoonSearchHotItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            titleLabel.textColor = RZCartoonTool.UIColorFromString(color_vaule: model.bgColor ?? "")
            titleLabel.text = model.name
        }
    }
    
}
