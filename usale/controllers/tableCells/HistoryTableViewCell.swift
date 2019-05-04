//
//  HistoryTableViewCell.swift
//  usale
//
//  Created by Ahmed masoud on 7/30/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var offerImg: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var offerDate: UILabel!
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
