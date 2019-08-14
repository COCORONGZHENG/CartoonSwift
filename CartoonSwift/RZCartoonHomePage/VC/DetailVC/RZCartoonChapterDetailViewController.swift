//
//  RZCartoonChapterDetailViewController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/6.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MJRefresh
class RZCartoonChapterDetailViewController: RZCartoonBaseViewController {

    var currentIndex : Int = 0
    var chapterList = [CartoonChapterStaticModel]()
    var chapterImgArr = [CartoonChapterImageModel]()
    var baseModel : CartoonHopeBaseModel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var naviHead : RZCartoonChapterHeader = {
        let head = RZCartoonChapterHeader()
        
        return head
    }()
    lazy var footer : RZCartoonChapterFooter = {
        let foot = RZCartoonChapterFooter()
        
        return foot
    }()
    
    lazy var baseScroll : UIScrollView = {
        let scroll = UIScrollView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapScrollViewAction))
        tap.numberOfTapsRequired = 1
        scroll.addGestureRecognizer(tap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapScrollViewAction))
        doubleTap.numberOfTapsRequired = 2
        scroll.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        scroll.delegate = self
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 1.5
        return scroll
    }()
    
    lazy var collect : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.register(RZCartoonChapterDetailCollecCell.classForCoder(), forCellWithReuseIdentifier: "RZCartoonChapterDetailCollecCell")
        collect.delegate = self
        collect.dataSource = self
        collect.backgroundColor = UIColor.bg_color
        collect.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getChapterDetailFromSever(true, isFirstLauch: false)
        })
        collect.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.getChapterDetailFromSever(false, isFirstLauch: false)
        })
        return collect
    }()
    
    private var isBarHidden : Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.naviHead.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.baseScroll).offset(self.isBarHidden ? -44 - self.edgeInsets.top : 0)
                })
                self.footer.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(self.baseScroll).offset(self.isBarHidden ? 120 + self.edgeInsets.bottom : 0)
                })
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    /// 获取当前的安全距离
    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    convenience init(_ model : CartoonHopeBaseModel,seleIndex : Int){
        self.init()
        self.currentIndex = seleIndex
        self.chapterList = model.chapter_list ?? []
        baseModel = model
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getChapterDetailFromSever(true, isFirstLauch: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.appDelegate.allowRotation = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func initUI() {
        view.addSubview(baseScroll)
        baseScroll.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
        }
        
        baseScroll.addSubview(collect)
        collect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalTo(baseScroll)
        }
        
        view.addSubview(naviHead)
        naviHead.snp.makeConstraints { make in
            make.top.left.right.equalTo(baseScroll)
            make.height.equalTo(44)
        }
        naviHead.titleLabel.text = baseModel?.comic?.name
        
        view.addSubview(footer)
        footer.CartoonChapterActionBlock { (sender) in
            switch sender?.tag {
            case CartoonChapterFootAction.deviceDirection.rawValue :
                print(1)
                
                self.appDelegate.allowRotation = !self.appDelegate.allowRotation
                if self.appDelegate.allowRotation {
                    let value = UIInterfaceOrientation.landscapeLeft.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
                } else {
                    let value = UIInterfaceOrientation.portrait.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
                }
                self.collect.reloadData()
                
                break
            case CartoonChapterFootAction.lighting.rawValue:
                
                break
            case CartoonChapterFootAction.chapterList.rawValue:
                self.navigationController?.popViewController(animated: true)
                break
                
            default:
                break
            }
            
        }
        footer.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(baseScroll)
            make.height.equalTo(120)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    func getChapterDetailFromSever(_ isHeadRefresh : Bool,isFirstLauch : Bool) {
        var requestIndex = 0
        if isFirstLauch { //是进来是调用的方法
            requestIndex = self.currentIndex
        } else {
            if isHeadRefresh {
                requestIndex = self.currentIndex - 1
                if requestIndex <= -1 {
                    RZProgressHUD.tost("现在已经是第一页了，上面没有了")
                    self.collect.mj_header.endRefreshing()
                    return
                }
            } else {
                requestIndex = self.currentIndex + 1
                if requestIndex >= self.chapterList.count - 1 {
                    RZProgressHUD.tost("已经加载完了所有了，么有了")
                    self.collect.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
            }
        }
        let chapter_id = self.chapterList[requestIndex].chapter_id
        RZCartoonHomePageVM().getChapterDetail(param: ["chapter_id" : chapter_id]) { (code, msg, json) in
            if code == 1 {
                let model = json as! CartoonChapterModel
                if isFirstLauch {
                    self.chapterImgArr = model.image_list!
                } else {
                    if isHeadRefresh {
                        self.chapterImgArr.insert(contentsOf: model.image_list ?? [], at: 0)
                        self.currentIndex -= 1
                        self.collect.mj_header.endRefreshing()
                    } else {
                        self.chapterImgArr.append(contentsOf: model.image_list ?? [])
                        if self.currentIndex == self.chapterList.count - 1 {
                            self.collect.mj_footer.endRefreshingWithNoMoreData()
                        } else {
                            self.collect.mj_footer.endRefreshing()
                        }
                        
                        self.currentIndex += 1
                        
                    }
                }
                self.collect.reloadData()
            } else {
                
            }
        }
    }
    
    @objc func tapScrollViewAction() {
        
        isBarHidden = !isBarHidden
        
    }
    
    @objc func doubleTapScrollViewAction() {
        let scale = baseScroll.zoomScale
        let targetScale = 2.5 - scale
        let zoomRect = CGRect(x: baseScroll.center.x - kScreenWidth / (2 * targetScale), y: baseScroll.center.y - kScreenHeight / (2 * targetScale), width: kScreenWidth / targetScale, height: kScreenHeight / targetScale)
        baseScroll.zoom(to: zoomRect, animated: true)
        
    }
    
}


extension RZCartoonChapterDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chapterImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collect.dequeueReusableCell(withReuseIdentifier: "RZCartoonChapterDetailCollecCell", for: indexPath) as! RZCartoonChapterDetailCollecCell
        cell.model = self.chapterImgArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.chapterImgArr[indexPath.item]
        print(kScreenWidth,"屏幕宽度",self.baseScroll.frame.size.width )
        let width = self.baseScroll.frame.size.width
        return CGSize(width: width, height: (CGFloat( model.height) / CGFloat(model.width)) * width)
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isBarHidden {
            self.isBarHidden = true
        }
    }
    
    /// 缩放时实现该代理方法 指定缩放的view
    ///
    /// - Parameter scrollView: 滚动视图
    /// - Returns: 缩放的view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == baseScroll {
            return collect
        } else {
            return UIView() // 注意这里不能return nil
        }
        
    }
    
    
}
