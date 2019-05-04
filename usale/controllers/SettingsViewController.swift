//
//  SettingsViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/30/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTbl: UITableView!
    
    var section: [String]!
    var items: [[ContactUsRecord]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        section = ["PERSONAL INFORMATION"]
        let userItem = ContactUsRecord(name: HelperData.sharedInstance.loggedInClient.name, image: #imageLiteral(resourceName: "profile.png"), type: nil)
        let emailItem = ContactUsRecord(name: HelperData.sharedInstance.loggedInClient.email, image: #imageLiteral(resourceName: "mail.png"), type: nil)
        let phoneItem = ContactUsRecord(name: HelperData.sharedInstance.loggedInClient.phone, image: #imageLiteral(resourceName: "phone.png"), type: nil)
        items = [
            [userItem, phoneItem, emailItem]
        ]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTbl.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! CategoryTableViewCell
        
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

}
