//
//  RZCartoonDefineFile.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//

import Foundation
import UIKit

var kScreenWidth = UIScreen.main.bounds.width
var kScreenHeight = UIScreen.main.bounds.height


let cartoonBaseURL = "http://app.u17.com/v3/appV3_3/ios/phone/"

let searchHistoryKey = "searchHistoryList"
let sexTypeKey = "sexTypeKey"


extension UIColor {
    class var bg_color : UIColor {
        return UIColor(r: 242, g: 242, b: 242, a: 1.0)
    }
    
    class var mainGreen: UIColor {
        return UIColor(r: 29, g: 221, b: 43,a:1.0)
    }
    
}


class RZCartoonTool : NSObject {
    
    class func isIPhoneX() ->Bool {
        let screenHeight = UIScreen.main.nativeBounds.size.height;
        if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
            return true
        }
        return false
    }
    
    class func getControllerfromview(view:UIView)->UIViewController?{
        var nextResponder: UIResponder? = view
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    
    class func UIColorFromString(color_vaule : String , alpha : CGFloat = 1) -> UIColor {
        
        if color_vaule.isEmpty {
            return UIColor.clear
        }
        
        var cString = color_vaule.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count == 0 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count < 6 && cString.count != 6 {
            
            return UIColor.clear
        }
        
        let value = "0x\(cString)"
        
        let scanner = Scanner(string:value)
        
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            print(hexValue)
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
            let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
            let blueValue = CGFloat(hexValue & 0xFF)/255.0
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            return UIColor.clear
        }
    }
    
    
    
}


