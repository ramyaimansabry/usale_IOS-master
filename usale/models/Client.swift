//
//  Client.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation

class Client: Decodable {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var token: String = ""
    
    fileprivate func constructDict() -> [String:Any]{
        return ["name":self.name,
                "email":self.email,
                "id":self.id,
                "phone":self.phone,
                "token":self.token]
    }
    
    func login() {
        let dict = self.constructDict()
        defaults.set(dict, forKey: "loggedInClient")
    }
}

