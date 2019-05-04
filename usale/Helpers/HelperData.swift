//
//  HelperData.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation
import UIKit
import JHSpinner
import BRYXBanner

enum ContactType {
    case phone
    case email
    case facebook
    case twitter
    case instagram
}

struct ContactUsRecord{
    var name: String!
    var image: UIImage!
    var type: ContactType!
}

class HelperData {
    static let sharedInstance = HelperData()
    final let serverBasePath = "http://usaleapp.com/apis/public/api"
    var loggedInClient: Client = Client()
    var FCM_TOKEN = ""
    private init(){}
    func constructBanner(title:String, description:String){
        let banner = Banner(title: title, subtitle: description, image: UIImage(named: "Icon"), backgroundColor: UIColor(rgb: 0xff0000))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
}
