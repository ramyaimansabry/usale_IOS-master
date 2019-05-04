//
//  ViewController.swift
//  usale
//
//  Created by Ahmed masoud on 7/28/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import JHSpinner
import AccountKit
import SCLAlertView

class RegisterViewController: UIViewController {
    var accountKit: AKFAccountKit!
    @IBOutlet weak var FacebookBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var separator: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if accountKit?.currentAccessToken != nil{
            let spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                spinner.dismiss()
                if let phoneNumber = account?.phoneNumber{
                    let stringPhone = phoneNumber.stringRepresentation()
                    ApiManager.sharedInstance.registerNewClient(email: self.emailTxt.text!, name: self.nameTxt.text!, phone: stringPhone, completed: { (valid,msg) in
                        if valid{
                            self.navigateToApp()
                        }else{
                            SCLAlertView().showError("Error", subTitle: msg)
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if accountKit == nil {
            accountKit = AKFAccountKit(responseType: .accessToken)
        }
        accountKit.logOut()
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        uiCustomization()
        addKeyboardObservers()
    }
    
    fileprivate func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func navigateToApp(){
        let storyboard = UIStoryboard(name: "Landing", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "landingTabBar")
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    fileprivate func uiCustomization(){
        FacebookBtn.backgroundColor = .clear
        FacebookBtn.layer.cornerRadius = 5
        FacebookBtn.layer.borderWidth = 1
        FacebookBtn.layer.borderColor = UIColor(rgb: 0x12418E).cgColor
        logoImg.layer.cornerRadius = 15
        logoImg.layer.masksToBounds = true
        separator.layer.cornerRadius = 2
    }
    
    @IBAction func loginFacebookAction(sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    self.nameTxt.text = ""
                    self.emailTxt.text = ""
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.loadProfile()
                }
            }
        }
    }
    
    fileprivate func fetchData(token: FBSDKAccessToken) {
        let spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.circular, overlayColor:UIColor.black.withAlphaComponent(0.6), attributedText: NSAttributedString(string: ""))
        view.addSubview(spinner)
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token.tokenString, version: nil, httpMethod: "GET")
        req?.start(completionHandler: { (_, result, error) in
            spinner.dismiss()
            if(error == nil)
            {
                let jsonReasult = result as! [String:Any]
                self.nameTxt.text = jsonReasult["name"] as? String
                self.emailTxt.text = jsonReasult["email"] as? String
            }
            else
            {
                print("error \(String(describing: error))")
            }
        })
    }
    
    fileprivate func loadProfile() {
        if let token = FBSDKAccessToken.current(){
            fetchData(token: token)
        }else{
            self.nameTxt.text = ""
            self.emailTxt.text = ""
        }
    }

    @IBAction func sendSMS(_ sender: Any) {
        if emailTxt.text == "" || nameTxt.text == ""{
            SCLAlertView().showError("Error", subTitle: "Please Fill In All The Fields")
            return
        }
        if !isValidEmail(testStr: emailTxt.text!) {
            SCLAlertView().showError("Error", subTitle: "Please Enter A Valid Email")
            return
        }
        let alertView = SCLAlertView()
        alertView.addButton("Show Terms And Privacy Policy",textColor:UIColor.white) {
            let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = myStoryboard.instantiateViewController(withIdentifier: "termsVC")
            self.present(destinationVC, animated: true, completion: nil)
        }
        alertView.addButton("Accept",textColor:UIColor.white) {
            let inputState = UUID().uuidString
            let vc = (self.accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
            self.prepareLoginViewController(loginViewController: vc)
            self.present(vc as UIViewController, animated: true, completion: nil)
        }
        alertView.showWarning("Confirmation", subTitle: "By Verifying Your Account You Agree To Our Terms Of Use And Privacy Policy",closeButtonTitle:"Cancel", colorStyle: 0xE91F1F, colorTextButton: 0xffffff)
    }
    
    fileprivate func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.whitelistedCountryCodes = ["EG"]
        loginViewController.enableSendToFacebook = true
        loginViewController.enableGetACall = true
        let theme:AKFTheme = AKFTheme.outline()
        theme.headerBackgroundColor = UIColor(rgb: 0xE91F1F)
        theme.backgroundColor = UIColor(rgb: 0xffffff)
        theme.headerButtonTextColor = UIColor(rgb: 0xE91F1F)
        theme.inputBackgroundColor = UIColor(rgb: 0xffffff)
        theme.inputBorderColor = UIColor(rgb: 0xE91F1F)
        theme.buttonBackgroundColor = UIColor(rgb: 0xffffff)
        theme.statusBarStyle = .lightContent
        theme.titleColor = UIColor(rgb: 0xE91F1F)
        theme.textColor = UIColor(rgb: 0xE91F1F)
        theme.headerTextColor = UIColor(rgb: 0xffffff)
        theme.inputTextColor = UIColor(rgb: 0xE91F1F)
        theme.buttonTextColor = UIColor(rgb: 0xE91F1F)
        theme.buttonBorderColor = UIColor(rgb: 0xE91F1F)
        theme.buttonDisabledTextColor = UIColor(rgb: 0xE91F1F)
        theme.buttonDisabledBorderColor = UIColor(rgb: 0xffffff)
        theme.iconColor = UIColor(rgb: 0xE91F1F)
        theme.buttonDisabledBackgroundColor = UIColor(rgb: 0xffffff)
        theme.buttonDisabledBorderColor = UIColor(rgb: 0xE91F1F)
        loginViewController.setTheme(theme)
    }
    
    fileprivate func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            var delta:CGFloat = 0.0
            let window = self.view.window?.frame.origin.y
            if window != nil{
                if CGFloat(window!) != 0{
                    return
                }
            }
            delta = -1 * keyboardHeight
            self.view.window?.frame.origin.y = delta / 2
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.window?.frame.origin.y = 0
            self.view.layoutIfNeeded()
        })
    }
    
}

