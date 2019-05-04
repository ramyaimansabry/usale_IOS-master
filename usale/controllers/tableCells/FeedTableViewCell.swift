//
//  FeedTableViewCell.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var offerImg: UIImageView!
    @IBOutlet weak var offerNameLbl: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var beforeLbl: UILabel!
    @IBOutlet weak var afterLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
