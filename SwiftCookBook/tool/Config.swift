//
//  Config.swift
//  CookBook--Swift
//
//  Created by ivna.evecom on 2018/3/14.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit

let screen_W:CGFloat = UIScreen.main.bounds.size.width

let screen_H:CGFloat = UIScreen.main.bounds.size.height


/// RGBA的颜色设置
func MQColor( r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

//背景颜色
func MQBackColor()  -> UIColor {
    return MQColor(r:54, g: 171, b: 254, a: 1)
}

let COOKTAGCHANGE:String = "cookTagChange"

/// iPhone 5
let isIPhone5 = screen_H == 568 ? true : false
/// iPhone 6
let isIPhone6 = screen_H == 667 ? true : false
/// iPhone 6P
let isIPhone6P = screen_H == 736 ? true : false

let fontSize16:CGFloat = isIPhone5 ? 14 : 16
let fontSize18:CGFloat = isIPhone5 ? 16 : 18
let fontSize14:CGFloat = isIPhone5 ? 12 : 14
let fontSize12:CGFloat = isIPhone5 ? 10 : 12
let fontSize22:CGFloat = isIPhone5 ? 20 : 22
let fontSize20:CGFloat = isIPhone5 ? 18 : 20
let fontSize24:CGFloat = isIPhone5 ? 22 : 24


extension String{
    //过滤中文编码
    func getUrlString() ->String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
