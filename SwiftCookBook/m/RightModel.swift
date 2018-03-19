//
//  RightModel.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/14.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import SwiftyJSON
class RightModel: NSObject {
    
    var cookId:String?
    var name:String?

    init(json:JSON) {
        cookId = json["id"].stringValue
        name   = json["name"].stringValue
    }

}
