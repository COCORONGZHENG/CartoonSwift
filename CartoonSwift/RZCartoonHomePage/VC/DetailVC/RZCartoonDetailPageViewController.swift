//
//  RZCartoonDetailPageViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/30.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MBProgressHUD
class RZCartoonDetailPageViewController: RZCartoonBaseViewController {

    lazy var detailConentVc : RZCartoonTabDetailViewController = {
        let vc = RZCartoonTabDetailViewController()
        vc.delegate = self
        return vc
    }()
    lazy var tabListVC : RZCartoonTableListViewController = {
        let vc = RZCartoonTableListViewController()
        vc.delegate = self
       return vc
    }()
    lazy var commentVC : RZCartoonCommentListViewController = {
        let vc = RZCartoonCommentListViewController()
        vc.delegate = self
        return vc
    }()
    lazy var pageVC : RZCartoonPageControlViewController = {
        
        let pageVC = RZCartoonPageControlViewController(["详情","目录","评论"], [detailConentVc,tabListVC,commentVC], .buttonSegument)
        return pageVC
    }()
    private lazy var navigationBarHei: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    lazy var baseScroll : UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.bounces = true
//        scroll.contentSize = CGSize(width: kScreenWidth, height: kScreenHeight + navigationBarHei + 150)
        return scroll
    }()
    
    var commic_id : Int = 0
    var header : RZCartoonDetailHeaderView?
    var hud : MBProgressHUD?
    var baseModel : CartoonHopeBaseModel?
    convenience init(commicID : Int?) {
        self.init()
        self.commic_id = commicID ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromSever()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.naviBarStyle(.clear)
    }
    override func configNavieBar() {
        super.configNavieBar()
        
    }

    
    override func initUI() {
        
        view.addSubview(baseScroll)
        baseScroll.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
                make.top.equalToSuperview()
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
            
        }
        
        header = RZCartoonDetailHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: navigationBarHei + 150))
        
        let contentView = UIView()
        baseScroll.addSubview(contentView) // scrollView 里面添加子视图  要固定高度 宽度
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-navigationBarHei)
    //        make.height.equalTo(kScreenHeight - navigationBarHei - 150 + 0.5)
        }
        
        
        addChild(pageVC)
        contentView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    //        baseScroll.safeAreaLayoutGuide
        baseScroll.parallaxHeader.view = header!
        baseScroll.parallaxHeader.height = navigationBarHei + 150
        baseScroll.parallaxHeader.minimumHeight = navigationBarHei
        baseScroll.parallaxHeader.mode = .fill
        
        
    }
    
    func getDataFromSever()  {
        RZProgressHUD.showHUD()
        let group = DispatchGroup()
        group.enter()
        RZCartoonHomePageVM().getCommicDetail(param: ["comicid" : self.commic_id]) { (code, msg, json) in
            let model = json as! CartoonHopeBaseModel
            self.baseModel = model
            self.detailConentVc.baseModel = model
            self.tabListVC.baseModel = model
            self.header?.model = model.comic
            print(model.chapter_list?.count ?? 0)
            if code == 1 {
                RZCartoonHomePageVM().getCommentList(param: ["object_id" : model.comic?.comic_id ?? 0,"thread_id" : model.comic?.thread_id ?? 0,"page" : -1], completeBlock: { (code, msg, json) in
                    if code == 1 {
                        let baseModel = json as! CartoonCommentBaseModel
                        self.commentVC.commentModel = baseModel
                        print("22", baseModel.commentList?.count ?? 0)
                    }
                    group.leave()
                })
            }
        }
        
        group.enter()
        RZCartoonHomePageVM().getRealTimeDetail(param: ["comicid" : self.commic_id]) { (code, msg, json) in
            if code == 1 {
                let realTimeModel = json as! CartoonDetailRealtimeModel
                self.detailConentVc.realTimeModel = realTimeModel.comic
                self.header?.realTimemodel = realTimeModel.comic
                print("333",realTimeModel.chapter_list?.count ?? 0)
                
            } else {
                
            }
            group.leave()
        }
        
        group.enter()
        RZCartoonHomePageVM().getGuessLikeList { (code, msg, json) in
            if code == 1 {
                let guessModel = json as! CartoonGuessLikeBaseModel
                self.detailConentVc.guessLikeModel = guessModel
                print("4444",guessModel.comics?.count ?? 0)
            } else {
                
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { //监听接口请求完毕 ，刷新界面
            RZProgressHUD.tost("接口都请求结束")
            RZProgressHUD.hideHUD()
            self.detailConentVc.reloadTableView()
            self.tabListVC.reloadData()
            self.commentVC.reloadData()
        }
        
    }
    
}

extension RZCartoonDetailPageViewController : UIScrollViewDelegate,RZCartoonScrollViewGestureDelegate {
//    RZCartoonScrollViewGestureDelegate
    func subViewControllerScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 0 {
            baseScroll.setContentOffset(CGPoint(x: 0,
                                                    y: -self.baseScroll.parallaxHeader.minimumHeight),
                                            animated: true)
        } else if scrollView.contentOffset.y < 0 {
            baseScroll.setContentOffset(CGPoint(x: 0,
                                                    y: -self.baseScroll.parallaxHeader.height),
                                            animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y,"22222")
        if scrollView.contentOffset.y >= -scrollView.parallaxHeader.minimumHeight {
            navigationController?.naviBarStyle(.green)
            navigationItem.title = baseModel?.comic?.name
        } else {
            navigationController?.naviBarStyle(.clear)
            navigationItem.title = ""
        }
    }
    
}
