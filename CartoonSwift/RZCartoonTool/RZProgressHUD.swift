//
//  RZProgressHUD.swift
//  CartoonSwift
//
//  Created by Mac on 2019/8/1.
//  Copyright © 2019 rz. All rights reserved.
//

import UIKit
import MBProgressHUD
class RZProgressHUD: NSObject {

    static var hud : MBProgressHUD?
    private class func createHud(view : UIView? = UIApplication.shared.keyWindow, isMask : Bool = false) -> MBProgressHUD? {
        guard let supview = view ?? UIApplication.shared.keyWindow else {return nil}
        let HUD = MBProgressHUD.showAdded(to: supview
            , animated: true)
        let naviHei = RZCartoonTool.isIPhoneX() ? 88.0 : 64.0
        let top : CGFloat = CGFloat(naviHei)
        HUD.frame = CGRect(x: 0, y: top, width: kScreenWidth, height: kScreenHeight - top)
        HUD.animationType = .zoom
        if isMask {
            /// 蒙层type,背景半透明.
            HUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        } else {
            /// 非蒙层type,没有背景.
            HUD.backgroundView.color = UIColor.clear
            HUD.bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            HUD.contentColor = UIColor.white
        }
        HUD.removeFromSuperViewOnHide = true
        HUD.show(animated: true)
        return HUD
    }
    
    class func showHUD(text : String? = nil,view : UIView? = UIApplication.shared.keyWindow,isMask : Bool = false) {
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .indeterminate
        HUD?.label.text = text
        hud = HUD
    }
    
    class func tost(_ text : String) {
        let HUD = self.createHud()
        HUD?.detailsLabel.text = text
        HUD?.mode = .text
        HUD?.hide(animated: true, afterDelay: 1.5)
    }
    
    
    class func hideHUD() {
        guard let HUD = hud else {
            return
        }
        HUD.hide(animated: true)
        hud = nil
    }
    
    
}
