//
//  BsNavitionVc.swift
//  Joke_Swift
//
//  Created by ivna.evecom on 2018/3/7.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit

class BsNavitionVc: UINavigationController,UIGestureRecognizerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setBackgroundImage(UIImage.init(named: "navigation_background"), for: .default)
        self.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 { /// 如果栈内还有控制器。
            viewController.hidesBottomBarWhenPushed = true 
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "lefterbackicon_titlebar_24x24_"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func navigationBack(){
        popViewController(animated: true)
    }
    /**
     * -- 侧滑返回手势
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if self.childViewControllers.count > 1 { ///如果不是栈顶控制器
            return true
        }else{
            return false
        }
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
