//
//  ViewController.swift
//  Wishbone Like App
//
//  Created by PC on 29/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var usernameTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().setDefaultBarStyle()
    }
    
    // MARK:- Button Click
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if usernameTxt.text?.trimmed.count == 0 && passwordTxt.text?.trimmed.count == 0 {
            displayToast("Please enter email/username and password")
        } else if usernameTxt.text?.trimmed.count == 0 {
            displayToast("Please enter email")
        } else if passwordTxt.text?.trimmed.count == 0 {
            displayToast("Please enter password")
        } else {
            // Pass Row Data In Multipart/Form-Data
            var param : [String : Any] = [String : Any]()
            let data: [String:Any] = ["email":usernameTxt.text!.trimmed,
                                      "userName":usernameTxt.text!.trimmed,
                                      "password":passwordTxt.text!.trimmed,
                                      "login":true]
            param["data"] = APIManager.shared.toJson(data)
            
            APIManager.shared.serviceCallToLogin(param) {
                AppDelegate().sharedDelegate().getUserDetail()
                AppDelegate().sharedDelegate().navigateToDashboard()
            }
        }
    }
    
    @IBAction func clickToForgetPassword(_ sender: Any) {
        self.view.endEditing(true)
        let vc : ForgetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToLoginWithFacebook(_ sender: Any) {
        self.view.endEditing(true)
        AppDelegate().sharedDelegate().loginWithFacebook()
    }
    
    @IBAction func clickToLoginWithGoogle(_ sender: Any) {
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func clickToSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
