//
//  RZCartoonSubscribeHomeViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/27.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
class RZCartoonSubscribeHomeViewController: RZCartoonBaseViewController {

    var subscribeList = [CartoonHopeModel]()
    
    lazy var collection : UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.backgroundColor = UIColor.bg_color
        collect.delegate = self
        collect.dataSource = self
        collect.register(RZCartoonHopeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonHopeCollectionViewCell")
        collect.register(RZHopeCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RZHopeCollectionReusableView")
        collect.register(RZHopeCollectionFooterReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RZHopeCollectionFooterReusableView")
        collect.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getSubscribeListFromSever()
        })
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubscribeListFromSever()
    }
    
    override func initUI() {
        super.initUI()
        view.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func getSubscribeListFromSever() {
        RZCartoonHomePageVM().getSubscribeList { (code, msg, json) in
            self.collection.mj_header.endRefreshing()
            if code == 1 {
                print(code)
                let model = json as! CartoonHopeBaseModel
                self.subscribeList = model.newSubscribeList!
                for item in self.subscribeList {
                    let width = floor((kScreenWidth - 10) / 3.0)
                    item.itemSize = CGSize(width: width, height: 240)
                }
                self.collection.reloadData()
                
            } else {
                
            }
        }
    }

}



extension RZCartoonSubscribeHomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.subscribeList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = self.subscribeList[section]
        return model.comics?.count ?? 0 // 最多取四个元素
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonHopeCollectionViewCell", for: indexPath) as! RZCartoonHopeCollectionViewCell
        let model = self.subscribeList[indexPath.section]
        cell.cellType = .withTitle
        cell.model = model.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let basemodel = self.subscribeList[indexPath.section]
        let model = basemodel.comics![indexPath.item]; navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: model.comicId), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RZHopeCollectionReusableView", for: indexPath) as! RZHopeCollectionReusableView
            header.model = self.subscribeList[indexPath.section]
            header.moreActionBlock {
                let basemodel = self.subscribeList[indexPath.section]
                let vc = RZCartoonCateDetailViewController(basemodel)
                vc.title = basemodel.itemTitle
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RZHopeCollectionFooterReusableView", for: indexPath) as! RZHopeCollectionFooterReusableView
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.subscribeList[indexPath.section]
        return model.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == self.subscribeList.count - 1 ? CGSize.zero : CGSize(width: kScreenWidth, height: 15)
    }
    
    
}
