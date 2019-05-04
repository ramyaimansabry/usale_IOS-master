//
//  FeedViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView
import JHSpinner
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var feedOffers:[Offer] = []
    @IBOutlet weak var feedTbl: UITableView!
    var spinner: JHSpinnerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Feed"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        loadFeed()
    }
    @IBAction func reloadFeed(_ sender: Any) {
        spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        loadFeed()
    }
    
    fileprivate func loadFeed(){
        ApiManager.sharedInstance.getFeedOffers { (valid, msg, offers) in
            self.spinner.dismiss()
            if valid{
                self.feedOffers = offers
                self.feedTbl.reloadData()
            }else{
                SCLAlertView().showError("Error", subTitle: msg)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTbl.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        let currentOffer = feedOffers[indexPath.row]
        cell.tag = indexPath.row
        cell.afterLbl.text = String(currentOffer.after)
        let attributedString = NSMutableAttributedString(string: String(currentOffer.before))
        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        cell.beforeLbl.attributedText = attributedString
        cell.offerImg.image = #imageLiteral(resourceName: "offerPlaceHolder.JPG")
        let tempImageView : UIImageView! = UIImageView()
        tempImageView.kf.setImage(with: URL(string:currentOffer.image)){ (image, error, type, url) in
            if(cell.tag == indexPath.row){
                if image == nil{
                    cell.offerImg.image = #imageLiteral(resourceName: "offerPlaceHolder.JPG")
                }else{
                    cell.offerImg.image = image
                }
            }
        }
        cell.offerNameLbl.text = currentOffer.merchant.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.feedTbl.deselectRow(at: indexPath, animated: true)
        let selectedOffer = feedOffers[indexPath.row]
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let detailsVc = storyboard.instantiateViewController(withIdentifier: "offerDetails") as! OfferDetailsViewController
        detailsVc.selectedOffer = selectedOffer
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    var shownIndexes : [IndexPath] = []
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: 200)
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
