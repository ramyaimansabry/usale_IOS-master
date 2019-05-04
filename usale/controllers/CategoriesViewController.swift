//
//  CategoriesViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoriesTbl: UITableView!
    
    let categories = Category.populateCategories()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Categories"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTbl.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        let category = categories[indexPath.row]
        cell.categoryNameLbl.text = category.name
        cell.categoryIcon.image = category.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoriesTbl.deselectRow(at: indexPath, animated: true)
        let selectedCategory = categories[indexPath.row]
        let storybboard = UIStoryboard(name: "Categories", bundle: nil)
        let vc = storybboard.instantiateViewController(withIdentifier: "merchantsList") as! MerchantsViewController
        vc.selectedCategory = selectedCategory
        self.navigationController?.pushViewController(vc, animated: true)
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
