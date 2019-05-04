//
//  MerchantDetailViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import Kingfisher

class MerchantDetailViewController: UIViewController {

    @IBOutlet weak var merchantImg: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantDescription: UILabel!
    @IBOutlet var viewHolders: [UIView]!
    @IBOutlet weak var merchantPhone: UILabel!
    @IBOutlet weak var merchantOpenClose: UILabel!
    @IBOutlet weak var merchantLocation: UILabel!
    var selectedMerchant: Merchant!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    
    fileprivate func loadUI(){
        self.navigationItem.title = "Info"
        if selectedMerchant.image == "" {
            merchantImg.image = #imageLiteral(resourceName: "merchantPlaceHolder.JPG")
        }else{
            merchantImg.kf.indicatorType = .activity
            merchantImg.kf.setImage(with: URL(string: selectedMerchant.image))
        }
        merchantName.text = selectedMerchant.name
        merchantDescription.text = selectedMerchant.description
        merchantPhone.text = selectedMerchant.phone
        merchantLocation.text = selectedMerchant.location
        merchantOpenClose.text = "From \(selectedMerchant.open) To \(selectedMerchant.close)"
        for viewHolder in viewHolders {
            viewHolder.layer.borderColor = UIColor.lightGray.cgColor
            viewHolder.layer.borderWidth = 1
        }
    }
    @IBAction func callMerchant(_ sender: Any) {
        merchantPhone.text?.makeAColl()
    }
    
}
