//
//  SearchCtrl.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/15.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
class SearchCtrl: UIViewController,UISearchBarDelegate {
    

    let identify = "identify"
    
    var currentP:Int = 0
    var totalPage:Int = 1
    var cid:String = "2"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        setUpUI()

        refreshHeaderData()
        
        let notifation = Notification.Name(rawValue: COOKTAGCHANGE)
        /**
         * -- 监听 通知事件
         */
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNoti(noti:)), name: notifation, object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func receiveNoti(noti:Notification){
        let useInfo = noti.userInfo as! [String:String]
        let value = useInfo["cid"]
        self.cid  = value!
        print("接收通知")
        print(self.cid)
        self.refreshHeaderData()
        
    }
    
    /**
     * -- 上拉刷新数据
     */
    @objc func refreshHeaderData(){
        ///清空所有数据
        self.dataArr.removeAll()
        NetWorkTool.shareNetWorkTool.cookIndexCidRequest(page:currentP,Cid: self.cid) { (models, currentP, totalP) in
            self.currentP = currentP
            self.dataArr = models
            self.totalPage = totalP / 10
            self.cookTable.reloadData()
            self.cookTable.mj_header.endRefreshing()
        }
        
    }
    /**
     * -- 加载更多数据
     */
    @objc func loadMoreData(){
        
        currentP = currentP + 1
        print(currentP)
        
        NetWorkTool.shareNetWorkTool.cookIndexCidRequest(page: currentP , Cid: "3") { (models, currentP, totalP) in
            for value in models{
                self.dataArr.append(value)
            }
            self.totalPage = totalP / 10
        
            self.cookTable.reloadData()
            if(self.currentP > self.totalPage){
                self.cookTable.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.cookTable.mj_footer.endRefreshing()
            }
            
        }
    }
    
    /**
     * -- 懒加载‘
     -- leftTable
     */
    fileprivate lazy var cookTable:UITableView = {
        let leftTab = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: screen_W, height: screen_H - 64 ), style: .plain)
        leftTab.delegate = self
        leftTab.dataSource = self
        /// 注册cell
        leftTab.register(UINib.init(nibName: "CookItemCell", bundle: Bundle.main), forCellReuseIdentifier: identify)
        leftTab.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshHeaderData))
        leftTab.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        leftTab.showsVerticalScrollIndicator = false
        leftTab.showsHorizontalScrollIndicator = false
        return leftTab
    }()
    
    fileprivate lazy var dataArr:[CookTagModel] = {
        return [CookTagModel]()
    }()
    
    
    func setUpUI()  {
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 10, y: 0, width: screen_W - 20, height: 45))
        searchBar.barStyle = .default
        searchBar.placeholder = "搜你想要的..."
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.orange
        searchBar.barTintColor = UIColor.gray
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
//        水平 垂直
        searchBar.searchTextPositionAdjustment = UIOffsetMake(20, 0)
//        searchBar TextField

        let searchField = searchBar.value(forKey: "_searchField") as! UITextField
        /// 通过kvc方法修改内部属性
        searchField.setValue(UIColor.gray, forKeyPath: "_placeholderLabel.textColor")
        searchField.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
        
        self.cookTable.tableHeaderView = searchBar
        
        self.view.addSubview(cookTable)
        
//        self.navigationItem.titleView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchCtrl:UITableViewDelegate,UITableViewDataSource{
    
    // MARK: dat
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return (self.dataArr.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identify) as! CookItemCell
        
        cell.reloadData(self.dataArr[indexPath.row])

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  240
    }
    /**
     * -- 单元格格点击事件
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let array = self.dataArr[indexPath.row].steps
        var imageList:[(title:String,url:String)] = []
        for value in array! {
            imageList.append((value["step"].stringValue,value["img"].stringValue))
        }
        let cookDetailVc = CookDetailCtrl()
        cookDetailVc.navigationItem.title = self.dataArr[indexPath.row].title
        cookDetailVc.imageList = imageList
        self.navigationController?.pushViewController(cookDetailVc, animated: true)
    }
    /**
     * -- 取消按钮点击事件 取消响应
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }
    /**
     * -- 搜索按钮点击事件 。执行搜索事件
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        var searchTxt = searchBar.text
        if (searchTxt?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请输入想要查询的菜名")
            return
        }else{
            //url 过滤中文编码
            // 请求到数据。 将原有数据删除， 赋值新数据 展示。
            //  没有请求到数据 提示。 搜不到...
            ///请求地址：http://apis.juhe.cn/cook/query.php
            //请求参数：menu=%E9%AA%A8&dtype=&pn=&rn=&albums=&key=43589755dfa048431ce4e330d2161238
        }
    }
}
