//
//  PostVC.swift
//  Wishbone Like App
//
//  Created by PC on 03/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class PostVC: UploadImageVC, UITextViewDelegate {
    
    @IBOutlet weak var twoImgView: UIView!
    @IBOutlet weak var threeImgView: UIView!
    @IBOutlet weak var fourImgView: UIView!
    
    @IBOutlet weak var twoImgBtn: UIButton!
    @IBOutlet weak var threeImgBtn: UIButton!
    @IBOutlet weak var fourImgBtn: UIButton!
    
    @IBOutlet weak var addTwoImgView: UIView!
    @IBOutlet weak var addThreeImgView: UIView!
    @IBOutlet weak var addFourImgView: UIView!
    
    @IBOutlet weak var twoImgBtn1: UIButton!
    @IBOutlet weak var twoImgBtn2: UIButton!
    @IBOutlet weak var threeImgBtn1: UIButton!
    @IBOutlet weak var threeImgBtn2: UIButton!
    @IBOutlet weak var threeImgBtn3: UIButton!
    @IBOutlet weak var fourImgBtn1: UIButton!
    @IBOutlet weak var fourImgBtn2: UIButton!
    @IBOutlet weak var fourImgBtn3: UIButton!
    @IBOutlet weak var fourImgBtn4: UIButton!
    
    @IBOutlet weak var twoImgCaptionTextView1: TextView!
    @IBOutlet weak var twoImgCaptionTextView2: TextView!
    
    @IBOutlet weak var threeImgCaptionTextView1: TextView!
    @IBOutlet weak var threeImgCaptionTextView2: TextView!
    @IBOutlet weak var threeImgCaptionTextView3: TextView!
    
    @IBOutlet weak var fourImgCaptionTextView1: TextView!
    @IBOutlet weak var fourImgCaptionTextView2: TextView!
    @IBOutlet weak var fourImgCaptionTextView3: TextView!
    @IBOutlet weak var fourImgCaptionTextView4: TextView!
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var addImageView: UIView!
    @IBOutlet weak var limitLbl: Label!
    
    var selectImgFlag:Int = 0
    var postImgFlag:Int = 2
    var postImageDict2 : [String:Any] = [String : Any]()
    var postImageDict3 : [String:Any] = [String : Any]()
    var postImageDict4 : [String:Any] = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetData()
    }
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
        limitLbl.isHidden = true
        
    }
    
    //MARK:- UITextViewDelegate Method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var maxCharacterLimit : Int = 20
        if textView == txtView
        {
            maxCharacterLimit = 45
        }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        if(changedText.length() > maxCharacterLimit && range.length == 0) {
            self.view.endEditing(true)
            displayToast("Enter only" + String(maxCharacterLimit) + "characters")
            return false;
        }
        limitLbl.text = String(maxCharacterLimit-changedText.length())
        return true;
    }
    
    
    // MARK:- Methods
    func resetData() {
        clickToTwoImage(self)
        
        txtView.text = ""
        postImageDict2["option1"] = nil
        postImageDict2["option2"] = nil
        postImageDict3["option1"] = nil
        postImageDict3["option2"] = nil
        postImageDict3["option3"] = nil
        postImageDict4["option1"] = nil
        postImageDict4["option2"] = nil
        postImageDict4["option3"] = nil
        postImageDict4["option4"] = nil
        
        twoImgBtn1.setImage(UIImage.init(named: "add_image"), for: .normal)
        twoImgBtn2.setImage(UIImage.init(named: "add_image"), for: .normal)
        
        threeImgBtn1.setImage(UIImage.init(named: "add_image"), for: .normal)
        threeImgBtn2.setImage(UIImage.init(named: "add_image"), for: .normal)
        threeImgBtn3.setImage(UIImage.init(named: "add_image"), for: .normal)
        
        fourImgBtn1.setImage(UIImage.init(named: "add_image"), for: .normal)
        fourImgBtn2.setImage(UIImage.init(named: "add_image"), for: .normal)
        fourImgBtn3.setImage(UIImage.init(named: "add_image"), for: .normal)
        fourImgBtn4.setImage(UIImage.init(named: "add_image"), for: .normal)
        
        twoImgCaptionTextView1.text = ""
        twoImgCaptionTextView2.text = ""
        
        threeImgCaptionTextView1.text = ""
        threeImgCaptionTextView2.text = ""
        threeImgCaptionTextView3.text = ""
        
        fourImgCaptionTextView1.text = ""
        fourImgCaptionTextView2.text = ""
        fourImgCaptionTextView3.text = ""
        fourImgCaptionTextView4.text = ""
    }
    
    func resetCustomTab() {
        twoImgView.isHidden = true
        threeImgView.isHidden = true
        fourImgView.isHidden = true
        
        twoImgBtn.isSelected = false
        threeImgBtn.isSelected = false
        fourImgBtn.isSelected = false
        
        addTwoImgView.isHidden = true
        addThreeImgView.isHidden = true
        addFourImgView.isHidden = true
    }
    
    override func selectedImage(choosenImage: UIImage) {
        switch selectImgFlag{
        case 1:
            postImageDict2["option1"] = choosenImage
            setImageToButton(button: twoImgBtn1, image: choosenImage)
            break
        case 2:
            postImageDict2["option2"] = choosenImage
            setImageToButton(button: twoImgBtn2, image: choosenImage)
            break
        case 3:
            postImageDict3["option1"] = choosenImage
            setImageToButton(button: threeImgBtn1, image: choosenImage)
            break
        case 4:
            postImageDict3["option2"] = choosenImage
            setImageToButton(button: threeImgBtn2, image: choosenImage)
            break
        case 5:
            postImageDict3["option3"] = choosenImage
            setImageToButton(button: threeImgBtn3, image: choosenImage)
            break
        case 6:
            postImageDict4["option1"] = choosenImage
            setImageToButton(button: fourImgBtn1, image: choosenImage)
            break
        case 7:
            postImageDict4["option2"] = choosenImage
            setImageToButton(button: fourImgBtn2, image: choosenImage)
            break
        case 8:
            postImageDict4["option3"] = choosenImage
            setImageToButton(button: fourImgBtn3, image: choosenImage)
            break
        case 9:
            postImageDict4["option4"] = choosenImage
            setImageToButton(button: fourImgBtn4, image: choosenImage)
            break
        default:
            break
        }
    }
    
    func setImageToButton(button : UIButton, image : UIImage)
    {
        button.setImage(image, for: .normal)
    }
    
    // MARK:- Button Click
    @IBAction func clickToClose(_ sender: Any) {
        self.view.endEditing(true)
        resetData()
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: ["tabIndex" : 0])
    }
    
    @IBAction func clickToShare(_ sender: Any) {
        self.view.endEditing(true)
        
        if txtView.text.trimmed.count == 0 {
            displayToast("Please enter caption")
            return
        }
        
        // Image Validation
        if postImgFlag == 2 {
            if postImageDict2["option1"] as? UIImage  == nil || postImageDict2["option2"] as? UIImage == nil{
                displayToast("Please upload image")
            }
            else if twoImgCaptionTextView1.text.trimmed == "" || twoImgCaptionTextView2.text.trimmed == "" {
                displayToast("Please add caption")
            }
            else {
                serviceCallToPost(postImageDict2)
            }
        } else if postImgFlag == 3 {
            if postImageDict3["option1"] == nil || postImageDict3["option2"] == nil || postImageDict3["option3"] == nil {
                displayToast("Please upload image")
            }else if threeImgCaptionTextView1.text.trimmed == "" || threeImgCaptionTextView2.text.trimmed == "" || threeImgCaptionTextView3.text.trimmed == "" {
                displayToast("Please add caption")
            }else {
                serviceCallToPost(postImageDict3)
            }
        } else if postImgFlag == 4 {
            if postImageDict4["option1"] == nil || postImageDict4["option2"] == nil || postImageDict4["option3"] == nil || postImageDict4["option4"] == nil{
                displayToast("Please upload image")
            }else if fourImgCaptionTextView1.text.trimmed == "" || fourImgCaptionTextView2.text.trimmed == "" || fourImgCaptionTextView3.text.trimmed == "" || fourImgCaptionTextView4.text.trimmed == "" {
                displayToast("Please add caption")
            } else {
                serviceCallToPost(postImageDict4)
            }
        }
    }
    
    func serviceCallToPost(_ dict : [String : Any])
    {
        var data : [String:Any] = [String:Any]()
        data["title"] = "rate one"
        data["content"] = txtView.text!.trimmed
        if postImgFlag == 2 {
            data["caption1"] = twoImgCaptionTextView1.text.trimmed
            data["caption2"] = twoImgCaptionTextView2.text.trimmed
        }
        else if postImgFlag == 3 {
            data["caption1"] = threeImgCaptionTextView1.text.trimmed
            data["caption2"] = threeImgCaptionTextView2.text.trimmed
            data["caption3"] = threeImgCaptionTextView3.text.trimmed
        }
        else if postImgFlag == 4 {
            data["caption1"] = fourImgCaptionTextView1.text.trimmed
            data["caption2"] = fourImgCaptionTextView2.text.trimmed
            data["caption3"] = fourImgCaptionTextView3.text.trimmed
            data["caption4"] = fourImgCaptionTextView4.text.trimmed
        }
        
        var param : [String : Any] = [String : Any]()
        param["data"] = APIManager.shared.toJson(data)
        print(param)
        APIManager.shared.serviceCallToCreatePost(posts: dict, param: param) {
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.GET_ALL_POPST), object: nil)
            self.clickToClose(self)
        }
        
    }
    
    @IBAction func clickToSelectImg(_ sender: UIButton) {
        self.view.endEditing(true)
        selectImgFlag = sender.tag
        uploadImage()
    }
    
    @IBAction func clickToTwoImage(_ sender: Any) {
        self.view.endEditing(true)
        resetCustomTab()
        twoImgView.isHidden = false
        twoImgBtn.isSelected = true
        addTwoImgView.isHidden = false
        displaySubViewtoParentView(addImageView, subview: addTwoImgView)
        postImgFlag = 2
    }
    
    @IBAction func clickToThreeImage(_ sender: Any) {
        self.view.endEditing(true)
        resetCustomTab()
        threeImgView.isHidden = false
        threeImgBtn.isSelected = true
        addThreeImgView.isHidden = false
        displaySubViewtoParentView(addImageView, subview: addThreeImgView)
        postImgFlag = 3
    }
    
    @IBAction func clickToFourImage(_ sender: Any) {
        self.view.endEditing(true)
        resetCustomTab()
        fourImgView.isHidden = false
        fourImgBtn.isSelected = true
        addFourImgView.isHidden = false
        displaySubViewtoParentView(addImageView, subview: addFourImgView)
        postImgFlag  = 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
