//
//  CookDetailCtrl.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/15.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit

class CookDetailCtrl: UIViewController{
    var sliderGalley:SliderGalleryController!
    var imageList:[(title:String,url:String)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.backgroundColor = UIColor.white
         sliderGalley = SliderGalleryController()
         sliderGalley.delegate = self
         sliderGalley.view.frame = CGRect.init(x: 0, y: 80, width: screen_W, height: screen_H * 0.3)
        
         self.view.addSubview(sliderGalley.view)
         self.addChildViewController(sliderGalley)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
// MARK: - UIScrollViewDelegate
extension CookDetailCtrl: SliderGalleryControllerDelegate {
    
    //图片轮播组件协议方法：获取内部scrollView尺寸
    func galleryScrollerViewSize() -> CGSize {
        return CGSize(width: screen_W, height: screen_H  * 0.3)
    }
    
    //图片轮播组件协议方法：获取数据集合
    func galleryDataSource() -> [(title:String,url:String)] {
        return self.imageList
    }
}
