//
//  NetWorkTool.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/14.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
/**
 * -- 网络请求工具类
 */
class NetWorkTool: NSObject {
    /**
     * -- 私有化init方法
     */
    fileprivate override init() {}
    /**
     * -- 创建实例
     */
    static let shareNetWorkTool = NetWorkTool()
    
    /**
     * -- 主页分类请求
     * -- 数据返回为 左右table [model]
     */
    func cookCategoryRequest(_ finished:@escaping(_ leftModels:[LeftModel],_ rightData:[[RightModel]] ) ->()){
        SVProgressHUD.showInfo(withStatus: "加载中...")
        let url = "http://apis.juhe.cn/cook/category?parentid=&dtype=&key=43589755dfa048431ce4e330d2161238"
        Alamofire.request(url).responseJSON { (response) in
            var leftModels = [LeftModel]()
//            var rightModels = [RightModel]()
            var rightData = [[RightModel]]() /// 套俩层
            guard response.result.isSuccess else{
                SVProgressHUD.showError(withStatus: "数据请求失败...")
                finished(leftModels,rightData) /// 请求失败返回空数据
                return
            }
            if let values = response.result.value{
                
               let json = JSON(values)
                let resultCode = json["resultcode"].stringValue
                if resultCode == "200"{
                    let resultArr = json["result"].arrayValue
                    for leftValue in resultArr{
                        leftModels.append(LeftModel.init(json: leftValue))
                        /// 外层中 每个分类对应着右边的每一个数组
                        var rightModels = [RightModel]()
                         let leftList = leftValue["list"].arrayValue
                        for rightV in leftList{/// 内层循环
                            rightModels.append(RightModel.init(json: rightV))
                        }
//                        数组 -> 数组 -> 模型
                      rightData.append(rightModels)
                    }
                    finished(leftModels,rightData)
                }else{
                    finished(leftModels,rightData) /// 校验码出错返回空数据
                }
            }else{
                finished(leftModels,rightData) /// 请求出错返回空数据
            }
            SVProgressHUD.dismiss()
        }
    }
   
    /**
     * --
     */
    
    /// 根据标签 请求 列表数据
    ///
    /// - Parameters:
    ///   - page: 当前页
    ///   - Cid: 当前标签
    ///   - finished: 结果回调
    func cookIndexCidRequest(page:Int,Cid:String,_ finished:@escaping(_ models:[CookTagModel],_ currentP:Int,_ totalNum:Int)->()){
        //cid=3&dtype=&pn=&rn=&format=&key=43589755dfa048431ce4e330d2161238
//        let url = "http://apis.juhe.cn/cook/index?" + "cid=\(Cid)" + "&dtype=&pn)&rn=&format=&key=43589755dfa048431ce4e330d2161238"
        let url = "http://apis.juhe.cn/cook/index?" + "cid=\(Cid)" + "&pn=\(page)" + "&dtype=&rn=&format=&key=43589755dfa048431ce4e330d2161238"
        Alamofire.request(url).responseJSON { (response) in
            var dataArrs = [CookTagModel]()
            guard response.result.isSuccess else{
                SVProgressHUD.showError(withStatus: "请求出错")
                finished(dataArrs,0,0)
                return
            }
            if let values = response.result.value{
                let json  = JSON(values)

                let resultCode = json["resultcode"].stringValue
                if resultCode == "200"{
                    let resultDic = json["result"].dictionary
                    let totalNum  = resultDic!["totalNum"]?.intValue
                    let currentP  = resultDic!["pn"]?.intValue
                    let dataArr = resultDic!["data"]?.arrayValue
                    for value in dataArr!{
                        dataArrs.append(CookTagModel.init(json: value))
                    }
                    finished(dataArrs,currentP!,totalNum!)
                }
                
            }
        }
    }
    
}
