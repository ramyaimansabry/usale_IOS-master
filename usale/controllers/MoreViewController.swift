//
//  MoreViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/30/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    fileprivate func navigateTo(identifier: String){
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func historyTap(_ sender: Any) {
        navigateTo(identifier: "historyList")
    }
    @IBAction func contactUsTap(_ sender: Any) {
        navigateTo(identifier: "contactUsPage")
    }
    @IBAction func settingsTap(_ sender: Any) {
        navigateTo(identifier: "settingsList")
    }
    @IBAction func infoTap(_ sender: Any) {
        navigateTo(identifier: "infoView")
    }
    @IBAction func favoritesTap(_ sender: Any) {
        navigateTo(identifier: "favoritesList")
    }
    
}
