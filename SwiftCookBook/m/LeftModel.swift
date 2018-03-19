//
//  LeftModel.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/14.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import SwiftyJSON
class LeftModel: NSObject {
    
    var parentId:Int?
    var name :String?
    init(json:JSON) {
        parentId = json["parentId"].int
        name     = json["name"].stringValue
    }

}
