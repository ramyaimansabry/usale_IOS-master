//
//  OfferDetailsViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import Kingfisher
import JHSpinner
import SCLAlertView

class OfferDetailsViewController: UIViewController {

    @IBOutlet weak var offerImg: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var afterPrice: UILabel!
    @IBOutlet weak var savedTextLbl: UILabel!
    @IBOutlet weak var remarksView: UIView!
    @IBOutlet weak var remarks: UILabel!
    var selectedOffer: Offer!
    var parentVc: OffersViewController?

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//         self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    fileprivate func updateUI(){
        self.navigationItem.title = selectedOffer.merchant.name
        offerImg.kf.indicatorType = .activity
        offerImg.kf.setImage(with: URL(string: selectedOffer.image))
        offerTitle.text = selectedOffer.title
        offerDescription.text = selectedOffer.description
        afterPrice.text = String(selectedOffer.after)
        let saved = selectedOffer.before - selectedOffer.after
        savedTextLbl.text = "You Saved \(saved) EGP"
        remarksView.layer.cornerRadius = 5
        if selectedOffer.merchant.remarks == "" {
            remarks.text = "* This Offer Is Available"
        }else{
            remarks.text = selectedOffer.merchant.remarks
        }
    }
    
    @IBAction func claimOffer(_ sender: Any) {
        let date = getDate()
        let time = getTime()
        let offerId = selectedOffer.id
        let merchantId = selectedOffer.merchant.id
        let alert = SCLAlertView()
        let merchantCodeTxt = alert.addTextField("Enter your code")
        
        alert.addButton("Redeem", backgroundColor: UIColor(rgb: 0xE91F1F), textColor: UIColor.white) {
            if let code = merchantCodeTxt.text{
                if code == "" {return}
                let spinner = JHSpinnerView.showOnView(self.view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
                ApiManager.sharedInstance.claimOffer(date: date, time: time, offerId: offerId, merchantCode: code, merchantId: merchantId, completed: { (valid, msg) in
                    spinner.dismiss()
                    if valid{
                        SCLAlertView().showSuccess("Congratulations", subTitle: msg)
                        if self.parentVc != nil{
                            self.parentVc?.redeemsCount = (self.parentVc?.redeemsCount!)! - 1
                        }
                        
                    }else{
                        SCLAlertView().showError("Error", subTitle: msg)
                    }
                })
            }
        }
        alert.showEdit("Claim Offer", subTitle: "Please Ask The Merchant To Enter His Code",closeButtonTitle: "Cancel", colorStyle: 0xE91F1F)
        
    }
    
    fileprivate func getTime() -> String{
        var time = ""
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        if hour <= 9{
            time += "0\(hour):"
        }else{
            time += "\(hour):"
        }
        if minutes <= 9{
            time += "0\(minutes)"
        }else{
            time += "\(minutes)"
        }
        return time
    }
    
    fileprivate func getDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
}
