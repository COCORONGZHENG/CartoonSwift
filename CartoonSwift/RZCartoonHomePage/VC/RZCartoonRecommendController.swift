//
//  RZCartoonRecommendController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//  推荐主页

import UIKit
import LLCycleScrollView
import MJRefresh
import SnapKit
import Alamofire
import RxSwift
import MBProgressHUD
class RZCartoonRecommendController: RZCartoonBaseViewController {

    // 模型
    private var comicListsArray = [CartoonHopeModel]()
    private var galleryItemsArray = [CartoonGalleryItemsModel]()
    private var textItemsArray = [CartoonTextItemsModel]()
    lazy var sexType : Int = {
        return UserDefaults.standard.integer(forKey: sexTypeKey)
    }()
    
    private lazy var bannerView : LLCycleScrollView = {
        
        let bannerView = LLCycleScrollView()
        bannerView.backgroundColor = UIColor.white
        bannerView.autoScrollTimeInterval = 5
        bannerView.placeHolderImage = UIImage(named: "normal_placeholder")
        bannerView.pageControlPosition = .center
        bannerView.pageControlBottom = 20
        bannerView.lldidSelectItemAtIndex = didseleted(index:)
        
        return bannerView
    }()
    
    private lazy var collectView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectView.backgroundColor = UIColor.bg_color
        collectView.delegate = self as UICollectionViewDelegate
        collectView.dataSource = self as UICollectionViewDataSource
        collectView.contentInset = UIEdgeInsets(top: kScreenWidth * 0.467, left: 0, bottom: 0, right: 0)
        collectView.register(RZCartoonHopeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonHopeCollectionViewCell")
        collectView.register(RZCartoonAnotherHopeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonAnotherHopeCollectionViewCell")
        collectView.register(RZHopeCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RZHopeCollectionReusableView")
        collectView.register(RZHopeCollectionFooterReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RZHopeCollectionFooterReusableView")
        collectView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDataFromSever(changeSex: false)
        })

        return collectView
    }()
    
    lazy var sexButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: self.sexType == 1 ? "gender_male" : "gender_female"), for: .normal)
        btn.addTarget(self, action: #selector(sexTypeChange(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDataFromSever(changeSex: false)
        
    }
    
    @objc func sexTypeChange(_ sender : UIButton) {
        loadDataFromSever(changeSex: true)
    }
    
    
    func loadDataFromSever(changeSex:Bool) {
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.setValue(sexType, forKey: sexTypeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(sexTypeKey), object: nil)
        }
        RZProgressHUD.showHUD()
        RZCartoonHomePageVM().getHomepageCartoonList(parameters: ["sexType" : sexType]) { (code, msg, json) in
            RZProgressHUD.hideHUD()
            self.collectView.mj_header.endRefreshing()
            if code == 1 {
                self.sexButton.setImage(UIImage(named: self.sexType == 1 ? "gender_male" : "gender_female"), for: .normal)
                let model = json as! CartoonHopeBaseModel
                self.comicListsArray = model.comicLists ?? []
                for hopeModel in self.comicListsArray {
                    print(hopeModel.comicType ,"哈哈哈")
                    switch hopeModel.comicType {
                        case .billboard: // floor 是获取一个数的最大整数 floor(3.14） = 3
                            let width = floor((kScreenWidth - 15.0) / 4.0)
                            hopeModel.itemSize = CGSize(width: width, height: 80)
                        break
                        case .thematic:
                            let width = floor((kScreenWidth - 5.0) / 2.0)
                            hopeModel.itemSize = CGSize(width: width, height: 120)
                        break
                        default:
                            let count = max(0, min(4, hopeModel.comics?.count ?? 0))
                            let warp = count % 2 + 2
                            let width = floor((kScreenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                            hopeModel.itemSize = CGSize(width: width, height: CGFloat(warp * 80))
                        break
                    }
                }
                
                self.galleryItemsArray = model.galleryItems ?? []
                self.textItemsArray = model.textItems ?? []
                self.bannerView.imagePaths = self.galleryItemsArray.filter({ (model) -> Bool in
                    model.cover != nil
                }).map({ (model) -> String in
                    model.cover!
                })
                self.collectView.reloadData()
            } else if code == -1 {
                RZProgressHUD.tost("请求失败")
            }
        }
        
        /**
       _ = RZCartoonHomePageVM().getHomepageCartoonList(parameters: ["sexType" : 1]).subscribe(onSuccess: { (x) in
            let dataArray = x.comicLists
            print(dataArray?.count as Any)
        }) { (error) in
            let err = error
            print(err)
        }
        */
    }
    
    
    override func initUI() {
        view.addSubview(collectView)
        collectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(collectView.contentInset.top)
        }
        
        view.addSubview(sexButton)
        sexButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-30)
            make.right.equalToSuperview()
        }
        
    }
    /**banner的点击事件*/
    func didseleted(index:NSInteger) {
        let model = self.galleryItemsArray[index]
        if model.linkType == 2 {
            /**compactMap函数 返回一个元素是String类型的数组，元素是item.val,joined函数将数组中的字符串元素转换为一个字符串直接使用*/
            guard let url = model.ext?.compactMap({ (item) -> String? in
                return item.key == "url" ? item.val : ""
            }).joined() else {return}
                let vc = RZCartoonBaseWebViewController(url: url)
                vc.title = model.title
              navigationController?.pushViewController(RZCartoonBaseWebViewController(url: url), animated: true)
        } else {
            guard let comicIdStr = model.ext?.compactMap({ (model) -> String? in
                return model.key == "comicId" ? model.val : ""
            }).joined(),
            let comicId = Int(comicIdStr) else {return}
        navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: comicId), animated: true)
            
            
        }
    }
}


extension RZCartoonRecommendController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicListsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comModel = comicListsArray[section]
        return comModel.comics?.prefix(4).count ?? 0 //prefix(4) 数组里面的元素大于4 取4 小于4 取数组元素数量
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let comModel = comicListsArray[indexPath.section]
        if (comModel.comicType == .billboard) {
            let cell = collectView.dequeueReusableCell(withReuseIdentifier: "RZCartoonAnotherHopeCollectionViewCell", for: indexPath) as! RZCartoonAnotherHopeCollectionViewCell
            cell.model = comModel.comics?[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RZCartoonHopeCollectionViewCell", for: indexPath) as! RZCartoonHopeCollectionViewCell
            if comModel.comicType == .thematic {
                cell.cellType = .withNone
            } else {
                cell.cellType = .withTitleAndSubTitle
            }
            cell.model = comModel.comics?[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comModel = comicListsArray[indexPath.section]
        return comModel.itemSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comModel = comicListsArray[indexPath.section]
        guard let item = comModel.comics?[indexPath.item] else {
            return
        }
        let model = comModel.comics?[indexPath.row]
        if item.linkType == 2 {
           guard let url = item.ext?.compactMap({ (model) -> String? in
                return model.key == "url" ? model.val : ""
            }).joined()
            else {return}
       
           let vc = RZCartoonBaseWebViewController(url: url)
           vc.title = item.title
           navigationController?.pushViewController(vc, animated: true)
            
        } else { navigationController?.pushViewController(RZCartoonDetailPageViewController(commicID: model?.comicId), animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RZHopeCollectionReusableView", for: indexPath) as! RZHopeCollectionReusableView
            
            let model = comicListsArray[indexPath.section]
            header.moreActionBlock {
                print("点击了更多")
                if model.comicType == .thematic {
                    let vc = RZCartoonPageControlViewController(["漫画","次元"], [RZCartoonAnimaDetailViewController(model),RZCartoonAnimaDetailViewController(model)], .naviSegument)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if model.comicType == .animation {
                    let vc = RZCartoonBaseWebViewController(url: "http://m.u17.com/wap/cartoon/list")
                    vc.title = "动画"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if model.comicType == .update {
                    let vc = RZCartoonAnimaDetailViewController(model)
                    vc.title = model.sortName
                    vc.isUpdate = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc = RZCartoonCateDetailViewController(model)
                    vc.title = model.sortName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            header.backgroundColor = .white
            header.model = comicListsArray[indexPath.section]
            return header
            
        } else {
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RZHopeCollectionFooterReusableView", for: indexPath) as! RZHopeCollectionFooterReusableView
            footer.backgroundColor = .bg_color
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == self.comicListsArray.count - 1 ? CGSize.zero : CGSize(width: kScreenWidth, height: 15)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectView {
            UIView.animate(withDuration: 0.4) {
                self.sexButton.snp.updateConstraints { (make) in
                    make.right.equalTo(0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.4) {
            self.sexButton.snp.updateConstraints { (make) in
                make.right.equalTo(50)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectView {
            bannerView.snp.updateConstraints { (make) in
                make.top.equalTo(min(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0))
                
            }
        }
    }
}
