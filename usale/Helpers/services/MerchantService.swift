//
//  MerchantService.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation
import Alamofire

extension ApiManager{
    func getGategoryMerchants(categoryId: Int, completed: @escaping (_ valid:Bool, _ msg:String, _ merchants:[Merchant])->()) {
        let url = "\(HelperData.sharedInstance.serverBasePath)/getCategoryMerchants?categoryId=\(categoryId)"
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                var merchants = [Merchant]()
                if valid{
                    for record in data["data"] as! [[String:Any]]{
                        let merchant = Merchant(merchantDict: record)
                        merchants.append(merchant)
                    }
                    completed(true,data["message"] as! String,merchants)
                    return
                }
                completed(false,data["message"] as! String,[])
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ",[])
            }
        }
    }
    
    func getMerchantOffers(merchantId: Int, completed: @escaping (_ valid:Bool, _ msg:String, _ offers:[Offer], _ favorites:[Int],_ redeemsCount: Int)->()) {
        let url = "\(HelperData.sharedInstance.serverBasePath)/getMerchantOffers?merchantId=\(merchantId)"
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let jsonRes = jsonResponse as! [String : Any]
                let data = jsonRes["data"] as! [String:Any]
                let offerRes = data["offers"] as! [[String:Any]]
                let redeems = data["redeems"] as! Int
                let valid = jsonRes["valid"] as! Bool
                var offers = [Offer]()
                var favorites = [Int]()
                if valid{
                    for record in offerRes {
                        let offer = Offer(offerDict: record)
                        let fav = record["favorite"] as! Int
                        offers.append(offer)
                        favorites.append(fav)
                    }
                    completed(true,jsonRes["message"] as! String,offers,favorites,redeems)
                    return
                }
                completed(false,jsonRes["message"] as! String,[],[],0)
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ",[],[],0)
            }
        }
    }
}
