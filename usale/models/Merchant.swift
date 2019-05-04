//
//  Merchant.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation

class Merchant {
    var id = 0
    var name = ""
    var description = ""
    var image = ""
    var phone = ""
    var open = ""
    var close = ""
    var location = ""
    var remarks = ""
    var maxDiscount = 0
    var area = ""
    
    init() {
        
    }
    
    init(merchantDict: [String:Any]) {
        self.id = merchantDict["id"] as! Int
        self.name = merchantDict["name"] as! String
        self.description = merchantDict["description"] as! String
        self.image = merchantDict["image"] as! String
        self.phone = merchantDict["phone"] as! String
        self.open = merchantDict["open"] as! String
        self.close = merchantDict["close"] as! String
        self.location = merchantDict["location"] as! String
        self.remarks = merchantDict["remarks"] as! String
        if let maxDiscount = merchantDict["maxDiscount"]{
            self.maxDiscount = maxDiscount as! Int
        }
        if let areaDic = merchantDict["area"] {
            let areaDict = areaDic as! [String:Any]
            self.area = areaDict["name"] as! String
        }
        
    }
}
