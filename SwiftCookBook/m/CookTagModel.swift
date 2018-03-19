//
//  CookTagModel.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/15.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import SwiftyJSON
class CookTagModel: NSObject {
    var cookId:String?
    var title:String?
    var tags:String?
    var imtro:String?
    var albums:String?
    var steps:[JSON]?
    
    init(json:JSON) {
        cookId = json["id"].stringValue
        title  = json["title"].stringValue
        tags   = json["tags"].stringValue
        imtro  = json["imtro"].stringValue
        albums = json["albums"].arrayValue.first?.stringValue
        steps  = json["steps"].arrayValue
    }
}
