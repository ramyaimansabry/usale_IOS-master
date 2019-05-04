//
//  TermsViewController.swift
//  usale
//
//  Created by Ahmed masoud on 1/1/19.
//  Copyright © 2019 Usale. All rights reserved.
//

import UIKit
import JHSpinner
import SCLAlertView

class TermsViewController: UIViewController {

    @IBOutlet weak var termsTxt: UITextView!
    var spinner: JHSpinnerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTermsAndConditions()
        // Do any additional setup after loading the view.
    }
    
    private func loadTermsAndConditions(){
        spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        ApiManager.sharedInstance.getTermsAndConditions { (valid, msg) in
            if valid{
                self.termsTxt.text = msg
                self.spinner.dismiss()
            }else{
                self.spinner.dismiss()
                SCLAlertView().showError("Error", subTitle: msg)
            }
        }
    }

    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
