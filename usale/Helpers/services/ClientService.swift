//
//  ClientService.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation
import Alamofire

extension ApiManager{
    
    func updateFCM(token: String, completed: @escaping (_ valid:Bool, _ msg:String)->()){
        let url = "\(HelperData.sharedInstance.serverBasePath)/updateUser"
        let parameters: Parameters = [
            "token" : token,
            ]
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                print("*************************************************************")
                print(jsonResponse)
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                if valid{
                    completed(true,data["message"] as! String)
                }
                completed(false,data["message"] as! String)
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ")
            }
        }
    }
    
    
    
    func registerNewClient(email: String, name: String, phone: String, completed: @escaping (_ valid:Bool, _ msg:String)->()){
        let url = "\(HelperData.sharedInstance.serverBasePath)/createUser"
        let parameters: Parameters = [
            "email" : email,
            "name" : name,
            "phone" : phone,
            "fcmToken": HelperData.sharedInstance.FCM_TOKEN,
            "password" : "0000"
        ]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            print(response.result.value ?? "---")
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                print("data ****************************************")
                print(data)
                let valid = data["valid"] as! Bool
                if valid{
                    if let theJSONData = try? JSONSerialization.data(withJSONObject: data["data"]!,options: []) {
                        guard let loggedInClient = try? JSONDecoder().decode(Client.self, from: theJSONData) else {
                            print("Error: Couldn't decode data into Client")
                            return
                        }
                        HelperData.sharedInstance.loggedInClient = loggedInClient
                        HelperData.sharedInstance.loggedInClient.login()
                        completed(true,data["message"] as! String)
                        return
                    }
                }
                completed(false,data["message"] as! String)
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ")
            }
        }
    }
    
    func claimOffer(date: String, time: String, offerId: Int, merchantCode: String, merchantId: Int,
                    completed: @escaping (_ valid:Bool, _ msg:String)->()) {
        let url = "\(HelperData.sharedInstance.serverBasePath)/redeemOffer"
        let parameters: Parameters = [
            "date" : date,
            "time" : time,
            "merchantPin" : merchantCode,
            "merchantId" : merchantId,
            "offerId" : offerId
        ]
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                let msg = data["message"] as! String
                completed(valid,msg)
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ")
            }
        }
    }
    
    func favoriteOffer(offerId: Int, favorite: Int, completed: @escaping (_ valid:Bool, _ msg:String)->()) {
        var url = ""
        if favorite == 1{
            url = "\(HelperData.sharedInstance.serverBasePath)/favoriteOffer"
        }else{
            url = "\(HelperData.sharedInstance.serverBasePath)/unFavoriteOffer"
        }
        let parameters: Parameters = [
            "offerId" : offerId
        ]
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                let msg = data["message"] as! String
                completed(valid,msg)
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ")
            }
        }
    }
    
    
    func getFavorites(completed: @escaping (_ valid:Bool, _ msg:String, _ offers:[Offer], _ favorites:[Int])->()) {
        let url = "\(HelperData.sharedInstance.serverBasePath)/getFavorites"
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                var offers = [Offer]()
                var favorites = [Int]()
                if valid{
                    for record in data["data"] as! [[String:Any]]{
                        let offer = Offer(offerDict: record)
                        offers.append(offer)
                        favorites.append(1)
                    }
                    completed(true,data["message"] as! String,offers,favorites)
                    return
                }
                completed(false,data["message"] as! String,[],[])
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ",[],[])
            }
        }
    }
    
    
    
    func getHistory(completed: @escaping (_ valid:Bool, _ msg:String, _ offers:[Offer], _ dates:[String])->())  {
        let url = "\(HelperData.sharedInstance.serverBasePath)/getUserHistory"
        let headers: HTTPHeaders = [
            "token": HelperData.sharedInstance.loggedInClient.token,
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                var offers = [Offer]()
                var dates = [String]()
                if valid{
                    for record in data["data"] as! [[String:Any]]{
                        let offer = Offer(offerDict: record)
                        let date = record["date"] as! String
                        offers.append(offer)
                        dates.append(date)
                    }
                    completed(true,data["message"] as! String,offers,dates)
                    return
                }
                completed(false,data["message"] as! String,[],[])
            }else{
                completed(false, "Unexpected Error Please Try Again In A While ",[],[])
            }
        }
    }
    
    func getTermsAndConditions(completed: @escaping (_ valid:Bool, _ terms:String)->()) {
        let url = "\(HelperData.sharedInstance.serverBasePath)/getTermsAndConditions"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            if let jsonResponse = response.result.value{
                let data = jsonResponse as! [String : Any]
                let valid = data["valid"] as! Bool
                if valid{
                    let terms = data["data"] as! String
                    completed(true,terms)
                    return
                }
                let msg = data["message"] as! String
                completed(false,msg)
            }else{
                completed(false,"Unable to reach server try again later")
            }
        }
    }
}
