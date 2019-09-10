//
//  ChangePasswordVC.swift
//  Wishbone Like App
//
//  Created by PC on 25/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var tokenTxt: TextField!
    @IBOutlet weak var passwordTxt: TextField!
    @IBOutlet weak var confirmPasswordTxt: TextField!
    
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.text = email
    }
    
    //MARK:- Button Click
    @IBAction func clickToBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0 {
            displayToast("Please enter email")
        } else if tokenTxt.text?.trimmed.count == 0 {
            displayToast("Please enter pin")
        } else if passwordTxt.text?.trimmed.count == 0 {
            displayToast("Please enter password")
        } else if confirmPasswordTxt.text?.trimmed.count == 0 {
            displayToast("Please confirm your password")
        } else if passwordTxt.text! != confirmPasswordTxt.text! {
            displayToast("Password miss match")
        } else {
            let param:[String:Any] = ["email":emailTxt.text!,
                                      "verificationToken":tokenTxt.text!,
                                      "password":passwordTxt.text!]
            APIManager.shared.serviceCallToResetPassword(param) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
