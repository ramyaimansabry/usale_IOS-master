//
//  OfferService.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation
import Alamofire

extension ApiManager{
    func getFeedOffers(completed: @escaping (_ valid:Bool, _ msg:String, _ offers:[Offer])->())  {
        let url = "\(HelperData.sharedInstance.serverBasePath)/getInLandingOffers"
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                print(data)
                let valid = data["valid"] as! Bool
                var offers = [Offer]()
                if valid{
                    for record in data["data"] as! [[String:Any]]{
                        let offer = Offer(offerDict: record)
                        offers.append(offer)
                    }
                    completed(true,data["message"] as! String,offers)
                    return
                }
                completed(false,data["message"] as! String,[])
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ",[])
            }
        }
    }
}
