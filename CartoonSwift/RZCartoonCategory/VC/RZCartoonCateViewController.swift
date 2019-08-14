//
//  RZCartoonCateViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
class RZCartoonCateViewController: RZCartoonBaseViewController {

    var cateList = [CartoonHopeModel]()
    lazy var searchView : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "请输入要搜索的关键字"
        return searchBar
    }()

    lazy var collect : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.backgroundColor = UIColor.bg_color
        collect.delegate = self
        collect.dataSource = self
        collect.register(RZCartoonCateCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonCateCollectionViewCell")
        collect.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getCateListFromSever()
        })
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCateListFromSever()
        
    }
    
    func getCateListFromSever() {
        RZProgressHUD.showHUD()
        RZCartoonHomePageVM().getCateList { (code, msg, json) in
            RZProgressHUD.hideHUD()
            self.collect.mj_header.endRefreshing()
            if code == 1 {
                let model = json as! CartoonHopeBaseModel
                self.cateList = model.rankingList ?? []
                for item in self.cateList {
                    let width = floor((kScreenWidth - 20) / 3.0)
                    item.itemSize = CGSize(width: width, height: width + 10)
                }
                self.collect.reloadData()
                print(json)
            } else {
                
                
            }
        };
        
    }

    override func initUI() {
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: 30))
        titleView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth - 60)
        }
        let btn = UIButton(type: .custom)
        _ = btn.rx.tap.subscribe { (event) in
        self.navigationController?.pushViewController(RZCartoonSearchHomeViewController(), animated: true)
        }
        titleView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth - 60)
        }
        navigationItem.titleView = titleView
        view.addSubview(collect)
        collect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
    
        }
    }
}


extension RZCartoonCateViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonCateCollectionViewCell", for: indexPath) as! RZCartoonCateCollectionViewCell
        cell.model = self.cateList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.cateList[indexPath.item]
        return model.itemSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.cateList[indexPath.item]
        let vc = RZCartoonCateDetailViewController(model)
        vc.title = model.sortName
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
