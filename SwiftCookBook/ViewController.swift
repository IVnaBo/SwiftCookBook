//
//  ViewController.swift
//  CookBook--Swift
//
//  Created by ivna.evecom on 2018/3/14.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let leftId:String = "LeftID"
    let rightId:String = "RightID"
    /**
     * -- 记录上次滚动偏移量
     */
    var lastOffsetY:CGFloat = 0
    var isScrollDown:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title  = "菜谱大全"
        self.view.addSubview(self.leftTable)
        self.view.addSubview(self.rightTable)
        NetWorkTool.shareNetWorkTool.cookCategoryRequest { (leftValue, rightValue) in

            self.leftData = leftValue
            self.rightData = rightValue
            self.leftTable.reloadData()
            self.rightTable.reloadData()

        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     * -- 懒加载‘
     -- leftTable
     */
    fileprivate lazy var leftTable:UITableView = {
        let leftTab = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: screen_H - 64 ), style: .plain)
        leftTab.delegate = self
        leftTab.dataSource = self
        leftTab.showsVerticalScrollIndicator = false
        leftTab.showsHorizontalScrollIndicator = false
        return leftTab
    }()
    /**
     * -- rightTable
     */
    fileprivate lazy var rightTable:UITableView = {
        let rightTab = UITableView.init(frame: CGRect.init(x: 130, y: 0, width: screen_W - 130, height: screen_H - 64 ), style: .plain)
        rightTab.delegate = self
        rightTab.dataSource = self
        rightTab.showsHorizontalScrollIndicator = false
        rightTab.showsVerticalScrollIndicator = false
        return rightTab
    }()
    //    MARK:懒加载数据源
    fileprivate lazy var leftData:[LeftModel] = {
        return [LeftModel]()
    }()
    fileprivate lazy var rightData:[[RightModel]] = {
        return [[RightModel]]()
    }()
    
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    /**
     * -- 俩个table 有多少个row
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView == self.leftTable){
            return self.leftData.count
        }else{
            return self.rightData[section].count
        }
    }
    /**
     * -- 有多少组 左边的是固定1组 右边的是左边的分类数
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == self.rightTable){
            return self.leftData.count
        }else{
            return 1
        }
    }
    /**
     * -- 根据tableView绘制cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == self.leftTable {
            var  cell = tableView.dequeueReusableCell(withIdentifier: leftId)
            if(cell == nil){
                cell = UITableViewCell.init(style: .default, reuseIdentifier: leftId)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell?.textLabel?.textAlignment = .center
            }
            cell?.textLabel?.text = self.leftData[indexPath.row].name
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: rightId)
            if cell == nil{
                cell = UITableViewCell.init(style: .default, reuseIdentifier: rightId)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell?.textLabel?.textAlignment = .center
//                print("11111")/// 测试重用
                print("section\(indexPath.section)   " + "  row\(indexPath.row)")
            }
            cell?.textLabel?.text = self.rightData[indexPath.section][indexPath.row].name
            return cell!
        }
    }
    /**
     * -- 表格头视图 只能右边有
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == self.rightTable){
            let headLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screen_W, height: 25))
            headLab.font = UIFont.systemFont(ofSize: 13)
            headLab.backgroundColor = UIColor.init(red: 244 / 255, green: 244 / 255, blue: 244 / 255, alpha: 1)
            headLab.text = self.leftData[section].name
            return headLab
        }else{
            return nil
        }
    }
    /**
     * -- 头视图高度
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == self.leftTable){ /// 去除左边第一个组的头视图
            return 0.01
        }else{
            return 25
        }
    }
    /**
     * -- 当点击了左边表格。右边做出相应响应
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.leftTable){
            let indexP = IndexPath.init(row: 0, section: indexPath.row)
            self.rightTable.scrollToRow(at: indexP, at: .top, animated: true)
            self.leftTable.scrollToRow(at: indexPath, at: .middle, animated: true)
        }else{
            
            let notifation = NSNotification.Name(rawValue:COOKTAGCHANGE)
            NotificationCenter.default.post(name: notifation, object: self, userInfo: ["cid":self.rightData[indexPath.section][indexPath.row].cookId ?? "3"])
            print("发送通知!")
            self.tabBarController?.selectedIndex = 1

        }
    }
    //    MARK:滚动相关代理方法
    /**
     * -- 往下滚动 scrollView.contentOffset.y 是正值逐步增大 往下滚动  逐步减小
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if rightTable == scrollView {
            print(scrollView.contentOffset.y)
            isScrollDown = lastOffsetY < scrollView.contentOffset.y  // 上次的比这次的小 说明是向下滚动
            lastOffsetY = scrollView.contentOffset.y /// 将上次滚动的距离纪录
        }
    }
    /**
     * -- 当拖动右边表格的同时 处理左边的表格
     */
    func selectRowAtIndexPath(indexP:Int)  {
        self.leftTable.selectRow(at: IndexPath.init(row: indexP, section: 0), animated: true, scrollPosition: .bottom)
    }
    /**
     * -- 分区头标题即将展示
     */
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
        if(rightTable == tableView ) && !isScrollDown && rightTable.isDragging{
            self.selectRowAtIndexPath(indexP: section)
        }
    }
    /**
     * -- 分区头标题展示结束
     */
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
         // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
        if(rightTable == tableView ) && isScrollDown && rightTable.isDragging{
            /** 向下滚动的话 则表示 左边的分类也应该向下移动一位 */
            self.selectRowAtIndexPath(indexP: section + 1)
        }
    }
}
