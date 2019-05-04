//
//  MerchantsViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import SCLAlertView
import JHSpinner

class MerchantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCategory: Category!
    var merchants = [Merchant]()
    var filteredMerchants = [Merchant]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var merchantsTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedCategory.name!
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Merchants"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // load merchants
        loadMerchants()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMerchants = merchants.filter({( merchant : Merchant) -> Bool in
            return merchant.name.lowercased().contains(searchText.lowercased())
        })
        
        merchantsTbl.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    fileprivate func loadMerchants(){
        let spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        let categoryId = selectedCategory.id
        ApiManager.sharedInstance.getGategoryMerchants(categoryId: categoryId!) { (valid, msg, merchants) in
            spinner.dismiss()
            if valid{
                self.merchants = merchants
                self.merchantsTbl.reloadData()
            }else{
                SCLAlertView().showError("Error", subTitle: msg)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMerchants.count
        }
        
        return merchants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = merchantsTbl.dequeueReusableCell(withIdentifier: "merchantCell", for: indexPath) as! MerchantTableViewCell
        let merchant: Merchant
        if isFiltering() {
            merchant = filteredMerchants[indexPath.row]
        } else {
            merchant = merchants[indexPath.row]
        }
        cell.merchantNameLbl.text = merchant.name
        cell.merchantLocationLbl.text = merchant.area
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        cell.mainView.layer.borderWidth = 1
        cell.maxDiscountLbl.text = "\(merchant.maxDiscount) %"
        cell.tag = indexPath.row
        cell.merchantImg.image = #imageLiteral(resourceName: "merchantPlaceHolder.JPG")
        let tempImageView : UIImageView! = UIImageView()
        tempImageView.kf.setImage(with: URL(string:merchant.image)){ (image, error, type, url) in
            if(cell.tag == indexPath.row){
                if image == nil{
                    cell.merchantImg.image = #imageLiteral(resourceName: "merchantPlaceHolder.JPG")
                }else{
                    cell.merchantImg.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        merchantsTbl.deselectRow(at: indexPath, animated: true)
        let merchant = merchants[indexPath.row]
        let storybobard = UIStoryboard(name: "Categories", bundle: nil)
        let vc = storybobard.instantiateViewController(withIdentifier: "offersList") as! OffersViewController
        vc.selectedMerchant = merchant
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var shownIndexes : [IndexPath] = []
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: 120)
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
