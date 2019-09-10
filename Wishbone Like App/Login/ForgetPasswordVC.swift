//
//  ForgetPasswordVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().setLightStatusBarStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate().sharedDelegate().setDefaultBarStyle()
    }
    
    // MARK:- Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text?.trimmed.count == 0 {
            displayToast("Please enter email.")
        } else {
            let param:[String:Any] = ["email":emailTxt.text!]
            APIManager.shared.serviceCallToChangePassword(param) {
                let alert = UIAlertController(title: "Change Password", message: "A link has been sent to your registered email to reset your password.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (ACTION) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                    vc.email = self.emailTxt.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                ok.setValue(GreenColor, forKey: "titleTextColor")
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
