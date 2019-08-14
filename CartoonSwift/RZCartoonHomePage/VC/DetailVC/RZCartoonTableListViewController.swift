//
//  RZCartoonTableListViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/30.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonTableListViewController: RZCartoonBaseViewController {

    weak var delegate : RZCartoonScrollViewGestureDelegate?
    var baseModel : CartoonHopeBaseModel?
    var tabList : [CartoonChapterStaticModel]?
    lazy var collect : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 34, right: 10)
        layout.itemSize = CGSize(width: floor((kScreenWidth - 30) / 2.0), height: 44)
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.delegate = self
        collect.dataSource = self
        collect.backgroundColor = .white
        collect.register(RZCartoonTabListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonTabListCollectionViewCell")
        collect.register(RZCartoonTabListTableHead.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RZCartoonTabListTableHead")
        return collect
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initUI() {
        view.addSubview(collect)
        collect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadData() {
        tabList = baseModel?.chapter_list
        collect.reloadData()
    }
}



extension RZCartoonTableListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonTabListCollectionViewCell", for: indexPath) as! RZCartoonTabListCollectionViewCell
        cell.model = tabList?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RZCartoonTabListTableHead", for: indexPath) as! RZCartoonTabListTableHead
            head.model = baseModel
            head.sortBlock { (btn) in
              self.tabList = self.tabList?.reversed()
              self.collect.reloadData()
            }
            return head
            
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = self.tabList?[indexPath.item]
        navigationController?.pushViewController(RZCartoonChapterDetailViewController(baseModel!,seleIndex: indexPath.item), animated: true)
        
        
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == collect {
            guard let delegate = delegate else {return}
            delegate.subViewControllerScrollViewDidScroll(scrollView)
        }
    }
    
    
}
