//
//  CookItemCell.swift
//  SwiftCookBook
//
//  Created by ivna.evecom on 2018/3/15.
//  Copyright © 2018年 ivna. All rights reserved.
//

import UIKit
import Kingfisher
class CookItemCell: UITableViewCell {

    @IBOutlet weak var cookImg: UIImageView!
    @IBOutlet weak var cookTitle: UILabel!
    @IBOutlet weak var imtro: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadData(_ model:CookTagModel)  {
        cookImg.kf.setImage(with: URL.init(string: model.albums!), placeholder: UIImage.init(named: "placehoder"), options: nil, progressBlock: nil, completionHandler: nil)
        cookTitle.text  = model.title
        imtro.text = model.imtro
    }
}
