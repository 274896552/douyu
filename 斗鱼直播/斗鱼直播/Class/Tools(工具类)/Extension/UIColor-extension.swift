//
//  UIColor-extension.swift
//  斗鱼直播
//
//  Created by schindler name on 2017/12/15.
//  Copyright © 2017年 hrx. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255.0, green: g/255.0 ,blue: b/255.0 ,alpha:1.0)
    }
}
