//
//  OffersViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import SCLAlertView
import JHSpinner

class OffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteOfferDelegate {

    var offers:[Offer] = []
    var favorites:[Int] = []
    var selectedMerchant: Merchant!
    var redeemsCount: Int? {
        didSet{
            self.mercahntRedeemsLbl.text = "You Have \(redeemsCount ?? 0) Redeems"
        }
    }
    @IBOutlet weak var offersTbl: UITableView!
    @IBOutlet weak var merchantImg: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantLocation: UILabel!
    @IBOutlet weak var mercahntRedeemsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    fileprivate func setUI(){
        self.navigationItem.title = "Offers"
        if selectedMerchant.image == "" {
            merchantImg.image = #imageLiteral(resourceName: "merchantPlaceHolder.JPG")
        }else{
            merchantImg.kf.indicatorType = .activity
            merchantImg.kf.setImage(with: URL(string: selectedMerchant.image))
        }
        merchantName.text = selectedMerchant.name
        merchantLocation.text = selectedMerchant.location
        loadOffers()
    }
    
    fileprivate func loadOffers(){
        let spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        let merchantId = selectedMerchant.id
        ApiManager.sharedInstance.getMerchantOffers(merchantId: merchantId) { (valid, msg, offers, favorites, redeemsCount)  in
            spinner.dismiss()
            if valid{
                self.redeemsCount = redeemsCount
                self.offers = offers
                self.favorites = favorites
                self.offersTbl.reloadData()
            }else{
                SCLAlertView().showError("Error", subTitle: msg)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMerchantDetails"{
            let vc = segue.destination as! MerchantDetailViewController
            vc.selectedMerchant = selectedMerchant
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let offer = offers[indexPath.row]
        let favorite = favorites[indexPath.row]
        let cell = offersTbl.dequeueReusableCell(withIdentifier: "offerCell", for: indexPath) as! OfferTableViewCell
        cell.offerNameLbl.text = offer.title
        cell.offerDescriptionLbl.text = offer.description
        cell.afterLbl.text = String(offer.after)
        cell.offerId = offer.id
        cell.favorite = favorite
        if favorite == 1 {
            cell.favoriteBtn.setBackgroundImage(#imageLiteral(resourceName: "onStar.png"), for: .normal)
        }else{
            cell.favoriteBtn.setBackgroundImage(#imageLiteral(resourceName: "offStar.png"), for: .normal)
        }
        let attributedString = NSMutableAttributedString(string: String(offer.before))
        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        cell.beforeLbl.attributedText = attributedString
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        cell.mainView.layer.borderWidth = 1
        cell.tag = indexPath.row
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.offersTbl.deselectRow(at: indexPath, animated: true)
        let selectedOffer = offers[indexPath.row]
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let detailsVc = storyboard.instantiateViewController(withIdentifier: "offerDetails") as! OfferDetailsViewController
        detailsVc.selectedOffer = selectedOffer
        detailsVc.parentVc = self
        self.navigationController?.pushViewController(detailsVc, animated: true)
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
    
    // delegate method called from cell class
    func offerFavorited(cell: OfferTableViewCell) {
        let offerId = cell.offerId!
        if cell.favorite == 1 {
            cell.favorite = 0
            favOffer(action: 0, offerId: offerId, cell: cell)
        }else{
            cell.favorite = 1
            favOffer(action: 1, offerId: offerId, cell: cell)
        }
        
        
    }
    
    fileprivate func favOffer(action: Int,offerId : Int, cell: OfferTableViewCell){
        cell.favoriteBtn.isEnabled = false
        ApiManager.sharedInstance.favoriteOffer(offerId: offerId, favorite: action) { (valid, msg) in
            cell.favoriteBtn.isEnabled = true
            if valid{
                if action == 1{
                    cell.favoriteBtn.setBackgroundImage(#imageLiteral(resourceName: "onStar.png"), for: .normal)
                }else{
                    cell.favoriteBtn.setBackgroundImage(#imageLiteral(resourceName: "offStar.png"), for: .normal)
                }
            }else{
                SCLAlertView().showError("Error", subTitle: msg)
            }
        }
    }


}
