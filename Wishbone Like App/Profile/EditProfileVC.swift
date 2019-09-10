//
//  EditProfileVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class EditProfileVC: UploadImageVC {
    
    @IBOutlet weak var selectImgBtn: Button!
    @IBOutlet weak var usernameTxt: TextField!
    @IBOutlet weak var emailTxt: TextField!
    
    var selectedImage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.isUserInteractionEnabled = false
        APIManager.shared.serviceCallToGetProfileImage(AppModel.shared.curruntUserDetail.picture, [selectImgBtn])
        usernameTxt.text = AppModel.shared.curruntUserDetail.userName
        emailTxt.text = AppModel.shared.curruntUserDetail.email
        
    }
    
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().setLightStatusBarStyle()
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }

    // MARK:- Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectImage(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        selectedImage = choosenImage
        selectImgBtn.setBackgroundImage(choosenImage.imageCropped(toFit: CGSize(width: selectImgBtn.frame.size.width, height: selectImgBtn.frame.size.height)), for: .normal)
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        self.view.endEditing(true)
        if usernameTxt.text?.trimmed.count == 0 {
            displayToast("Enter username")
        } else if selectImgBtn.backgroundImage(for: .normal) == nil {
            displayToast("Please wait profile loaded..")
        }
        else {
            var param:[String:Any] = [String:Any]()
            if usernameTxt.text?.trimmed != AppModel.shared.curruntUserDetail.userName
            {
                param["data"] = APIManager.shared.toJson(["userName" : usernameTxt.text!.trimmed])
            }
            
            if param.count > 0 || selectedImage != nil
            {
                APIManager.shared.serviceCallToUpdateUser(selectedImage, param) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
