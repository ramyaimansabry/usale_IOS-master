//
//  HistoryViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/30/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher
import JHSpinner

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var histroyTbl: UITableView!
    var offers = [Offer]()
    var dates = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "History"
        loadHistory()
    }
    
    fileprivate func loadHistory(){
        let spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        ApiManager.sharedInstance.getHistory { (valid, msg, offers, dates) in
            spinner.dismiss()
            if valid{
                self.offers = offers
                self.dates = dates
                self.histroyTbl.reloadData()
            }else{
                SCLAlertView().showError("Error", subTitle: msg)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let offer = offers[indexPath.row]
        let cell = histroyTbl.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        cell.offerTitle.text = offer.title
        cell.offerDescription.text = offer.description
        cell.offerDate.text = dates[indexPath.row]
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        cell.mainView.layer.borderWidth = 1
        cell.tag = indexPath.row
        cell.offerImg.image = #imageLiteral(resourceName: "offerPlaceHolder.JPG")
        let tempImageView : UIImageView! = UIImageView()
        tempImageView.kf.setImage(with: URL(string:offer.image)){ (image, error, type, url) in
            if(cell.tag == indexPath.row){
                if image == nil{
                    cell.offerImg.image = #imageLiteral(resourceName: "offerPlaceHolder.JPG")
                }else{
                    cell.offerImg.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
