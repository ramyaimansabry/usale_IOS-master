//
//  OfferTableViewCell.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

protocol FavoriteOfferDelegate {
    func offerFavorited(cell: OfferTableViewCell)
}

class OfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var offerImg: UIImageView!
    @IBOutlet weak var offerNameLbl: UILabel!
    @IBOutlet weak var offerDescriptionLbl: UILabel!
    @IBOutlet weak var beforeLbl: UILabel!
    @IBOutlet weak var afterLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var favoriteBtn: UIButton!
    var offerId: Int!
    var favorite: Int!
    
    var delegate: FavoriteOfferDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        delegate?.offerFavorited(cell: self)
    }
    
}
