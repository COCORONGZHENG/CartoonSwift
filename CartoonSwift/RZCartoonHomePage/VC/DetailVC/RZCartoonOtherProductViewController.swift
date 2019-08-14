//
//  RZCartoonOtherProductViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/2.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonOtherProductViewController: RZCartoonBaseViewController {

    var otherProductList = [CartoonDetailStaticModel]()
    lazy var collect : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: floor((kScreenWidth - 40) / 3.0) , height: 240)
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.register(RZCartoonHopeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonHopeCollectionViewCell")
        collect.delegate = self
        collect.dataSource = self
        collect.backgroundColor = .white
        return collect
    }()
    
    convenience init(_ otherProList : [CartoonDetailStaticModel]) {
        self.init()
        otherProductList = otherProList
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.naviBarStyle(.green)
    }

    override func initUI() {
        navigationItem.title = "其他作品"
        view.addSubview(collect)
        collect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension RZCartoonOtherProductViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonHopeCollectionViewCell", for: indexPath) as! RZCartoonHopeCollectionViewCell
        cell.cellType = .withTitleAndSubTitle
        cell.otherProductModel = self.otherProductList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.otherProductList[indexPath.item]
        navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: model.comicId), animated: true)
        
    }
    
    
}
