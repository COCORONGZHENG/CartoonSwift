//
//  RZCartonBaseTabbarController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartonBaseTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = false // 可以解决tableview edge。0 时多了一个tabbar高度的bug，
        setupChildViewController()
    }
    
    func setupChildViewController() {
        
        let homePageVc = RZCartoonHomePageViewController(["推荐","VIP","订阅","排行"], [ RZCartoonRecommendController(),RZCartoonVipHomeViewController(),RZCartoonSubscribeHomeViewController(),RZCartoonSortHomeViewController()], .naviSegument)
        addChildVCToTabbarController(homePageVc, title: "首页", image: "tab_book", seleImg: "tab_book_S")
        let cateVC = RZCartoonCateViewController()
        addChildVCToTabbarController(cateVC, title: "分类", image: "tab_class", seleImg: "tab_class_S")
//        let bookVC = RZCartoonBookViewController()
        let bookVC = RZCartoonCateViewController()
        addChildVCToTabbarController(bookVC, title: "书架", image: "tab_book", seleImg: "tab_book_S")
        let mineVC = RZCartoonMineViewController()
        addChildVCToTabbarController(mineVC, title: "我的", image: "tab_mine", seleImg: "tab_mine_S")
        
    }

    func addChildVCToTabbarController(_ childVC:UIViewController,title:String,image:String,seleImg:String) {
        childVC.title = title
        childVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: image)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: seleImg)?.withRenderingMode(.alwaysOriginal))
        if UIDevice.current.userInterfaceIdiom == .phone {
            childVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(RZCartoonBaseNaviController(rootViewController: childVC))
        
    }

}

extension RZCartonBaseTabbarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else {
            return .lightContent
        }
        return select.preferredStatusBarStyle
    }
    
}
