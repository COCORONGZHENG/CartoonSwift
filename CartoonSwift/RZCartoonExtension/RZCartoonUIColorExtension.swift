//
//  RZCartoonUIColorExtension.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/22.
//  Copyright © 2019 rz. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(r:Int,g:Int,b:Int,a:CGFloat) {
        self.init(red:CGFloat(r) / 255.0,green:CGFloat(g) / 255.0,blue:CGFloat(b) / 255.0,alpha:a)
    }

    
    
    func image() -> UIImage { //输入颜色返回颜色的图片
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
