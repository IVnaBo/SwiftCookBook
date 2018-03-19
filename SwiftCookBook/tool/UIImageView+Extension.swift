//
//  UIImageView+Extension.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/15.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView{
    
    func setImageByUrl(_ url: String,_ imgName:String) {
        let placeholder = UIImage(named: imgName)
        if url == ""{
            self.image = placeholder
        }
        else{
            let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            //self.kf.setImage(with:URL(string: url!)!)
            //print(url!)
            self.kf.setImage(with: URL(string: url!)!, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler:  { (image, error, cacheType, imageURL) in
                self.image = (image == nil) ? placeholder : image
            }
            )
        }
    }
    
    func setImageByUrl(_ url: String) {
        
        let placeholder = UIImage(named: "default5")
        if url == ""{
            self.image = placeholder
        }
        else{
            let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            //self.kf.setImage(with:URL(string: url!)!)
            //print(url!)
            self.kf.setImage(with: URL(string: url!)!, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler:  { (image, error, cacheType, imageURL) in
                self.image = (image == nil) ? placeholder : image
            }
            )
        }
    }
}
