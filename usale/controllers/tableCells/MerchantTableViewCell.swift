//
//  MerchantTableViewCell.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class MerchantTableViewCell: UITableViewCell {

    @IBOutlet weak var merchantImg: UIImageView!
    @IBOutlet weak var merchantNameLbl: UILabel!
    @IBOutlet weak var merchantLocationLbl: UILabel!
    @IBOutlet weak var maxDiscountLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
