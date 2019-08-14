//
//  RZCartoonBaseNaviController.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit

class RZCartoonBaseNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    

}

enum RZCartoonNaviBarStyle {
    case white
    case green
    case clear
}

extension UINavigationController {
    /**navigationBar.setBackgroundImage 方法可以解决顶部导航栏覆盖table的问题*/
    func naviBarStyle(_ style : RZCartoonNaviBarStyle)  {
        switch style {
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
            break
        case .green:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
            break
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            break
        }
        
        
    }
    
    
}
