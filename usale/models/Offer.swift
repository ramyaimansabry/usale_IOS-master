//
//  Offer.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation

class Offer {
    var id = 0
    var title = ""
    var description = ""
    var image = ""
    var before = 0
    var after = 0
    var merchant = Merchant()
    
    init(offerDict: [String:Any]) {
        self.id = offerDict["id"] as! Int
        self.title = offerDict["title"] as! String
        self.description = offerDict["description"] as! String
        self.image = offerDict["image"] as! String
        self.before = offerDict["before"] as! Int
        self.after = offerDict["after"] as! Int
        if let merchant = offerDict["merchant"]{
            self.merchant = Merchant(merchantDict: merchant as! [String:Any])
        }
    }
}
