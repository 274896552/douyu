//
//  UIBarButtonItem-extension.swift
//  斗鱼直播
//
//  Created by schindler name on 2017/12/14.
//  Copyright © 2017年 hrx. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
//    class func createItem(imageName :String,endImageName:String ,Size :CGSize) -> UIBarButtonItem{
//        let bt=UIButton()
//        bt.setImage(UIImage(named:imageName), for: .normal)
//        bt.setImage(UIImage(named:endImageName), for: .highlighted)
//        bt.frame=CGRect(origin:.zero ,size:Size)
//        return UIBarButtonItem(customView: bt)
//    }
    convenience init(imageName :String,endImageName:String="" ,Size :CGSize=CGSize.zero){
        let bt=UIButton()
        bt.setImage(UIImage(named:imageName), for: .normal)
        if (endImageName != ""){
            bt.setImage(UIImage(named:endImageName), for: .highlighted)
        }
        if (Size==CGSize.zero){
            bt.sizeToFit()
        }else{
            bt.frame=CGRect(origin:.zero,size:Size)
        }
        self.init(customView: bt)
    }
    
}
