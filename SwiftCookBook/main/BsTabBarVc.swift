//
//  BsTabBarVc.swift
//  Joke_Swift
//
//  Created by ivna.evecom on 2018/3/7.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit

class BsTabBarVc: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 添加子控制器
    func addChildViewControllers()  {
        
        setChildViewController(ViewController(), title: "分类", imgName: "首页")
        setChildViewController(SearchCtrl(), title: "推荐", imgName: "教玩具")
        
    }
    ///初始化 子控制器
    private func setChildViewController(_ childController :UIViewController,title:String,imgName:String){
        childController.tabBarItem.title = title
        /// 默认状态下的图标
        childController.tabBarItem.image = UIImage.init(named: imgName + "_1")?.withRenderingMode(.alwaysOriginal)
        /// 选中状态下的图标
        childController.tabBarItem.selectedImage = UIImage.init(named: imgName)?.withRenderingMode(.alwaysOriginal)
        
        let navVc = BsNavitionVc.init(rootViewController: childController)
        addChildViewController(navVc)
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
