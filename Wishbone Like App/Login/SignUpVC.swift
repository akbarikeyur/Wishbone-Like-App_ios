//
//  SignUpVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class SignUpVC: UploadImageVC {
    
    @IBOutlet weak var selectImgBtn: Button!
    @IBOutlet weak var usernameTxt: TextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    var selectedProfileImg:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- Button Click
    @IBAction func clickToSelectImg(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        selectedProfileImg = choosenImage
        selectImgBtn.setImage(choosenImage.imageCropped(toFit: CGSize(width: selectImgBtn.frame.size.width, height: selectImgBtn.frame.size.height)), for: .normal)
    }

    @IBAction func clickToSignUp(_ sender: Any) {
        self.view.endEditing(true)
        if usernameTxt.text?.trimmed.count == 0 {
            displayToast("Please enter username")
        } else if emailTxt.text?.trimmed.count == 0 {
            displayToast("Please enter email")
        } else if passwordTxt.text?.trimmed.count == 0 {
            displayToast("Please enter password")
        } else if confirmPasswordTxt.text?.trimmed.count == 0 {
            displayToast("Please enter confirm password")
        } else if passwordTxt.text != confirmPasswordTxt.text {
            displayToast("Password miss match..!")
        } else if self.selectedProfileImg == nil {
            displayToast("Please select profile image")
        }
        else {
            var param : [String : Any] = [String : Any]()
            let data: [String:Any] = ["email":self.emailTxt.text!.trimmed,
                                      "userName":self.usernameTxt.text!.trimmed,
                                      "password":self.passwordTxt.text!.trimmed,
                                      "login":false]
            param["data"] = APIManager.shared.toJson(data)
            
            APIManager.shared.serviceCallToCreateUser(profile: self.selectedProfileImg!, param, {
                let alert = UIAlertController(title: "Verification", message: "An email has been sent to you please verify your email in your inbox to login.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (Action) in
                    self.navigationController?.popViewController(animated: true)
                }
                ok.setValue(GreenColor, forKey: "titleTextColor")
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
