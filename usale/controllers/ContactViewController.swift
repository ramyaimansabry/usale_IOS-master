//
//  ContactViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/30/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTbl: UITableView!
    
    var section: [String]!
    var items: [[ContactUsRecord]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Contact Us"
        section = ["CUSTOMER SUPPORT", "SOCIAL MEDIA"]
        let phoneItem = ContactUsRecord(name: "+201064465652", image: #imageLiteral(resourceName: "phone.png"), type: .phone)
        let emailItem = ContactUsRecord(name: "info@usale.com", image: #imageLiteral(resourceName: "mail.png"), type: .email)
        let facebookItem = ContactUsRecord(name: "Facebook", image: #imageLiteral(resourceName: "fbLogo.png"), type: .facebook)
        let twitterItem = ContactUsRecord(name: "Twitter", image: #imageLiteral(resourceName: "twitter.png"), type: .twitter)
        let instagramItem = ContactUsRecord(name: "Instagram", image: #imageLiteral(resourceName: "instagram.png"), type: .instagram)
        items = [
            [phoneItem, emailItem],
            [facebookItem,twitterItem,instagramItem]
        ]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTbl.dequeueReusableCell(withIdentifier: "contactUsCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryNameLbl.text = self.items[indexPath.section][indexPath.row].name!
        cell.categoryIcon.image = self.items[indexPath.section][indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    var shownIndexes : [IndexPath] = []
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: 55)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTbl.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        let selectedItem = items[section][row]
        switch selectedItem.type {
        case .phone?:
            selectedItem.name.makeAColl()
        case .instagram?:
            UIApplication.tryURL(urls: [
                "instagram://user?username=usale_app", // App
                "https://www.instagram.com/usale_app/" // Website if app fails
                ])
        case .facebook?:
            UIApplication.tryURL(urls: [
                "fb://profile/2161233514148406", // App
                "https://www.facebook.com/usale.discount.store/" // Website if app fails
                ])
        case .twitter?:
            UIApplication.tryURL(urls: [
                "twitter://user?screen_name=USaleapp", // App
                "https://twitter.com/USaleapp" // Website if app fails
                ])
        case .email?:
            let email = selectedItem.name!
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        default:
            print("default")
        }
    }

}
