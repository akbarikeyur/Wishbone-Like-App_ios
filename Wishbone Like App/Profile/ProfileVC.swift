//
//  ProfileVC.swift
//  Wishbone Like App
//
//  Created by PC on 03/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var profileImg: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var postedBtn: UIButton!
    @IBOutlet weak var postedView: UIView!
    @IBOutlet weak var votedBtn: UIButton!
    @IBOutlet weak var votedView: UIView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var votedCollectionView: UICollectionView!
    
    @IBOutlet weak var postedNoDataLbl: Label!
    @IBOutlet weak var votedNoDataLbl: Label!
    
    @IBOutlet weak var postedBackView: UIView!
    @IBOutlet weak var votedBackView: UIView!

    var headerFlag:Bool = true
    var profilePostList:[PostListModel] = [PostListModel]()
    var votedPostList:[PostListModel] = [PostListModel]()
    
    var refreshProfilePost : UIRefreshControl = UIRefreshControl.init()
    var refreshVotedPost : UIRefreshControl = UIRefreshControl.init()
    
    var userPostPage = 1
    var userPostLimit = 30
    var isLoadNextUserPostData = true
    
    var votedPostPage = 1
    var votedPostLimit = 30
    var isLoadNextVotedPostData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetail), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        
        postedNoDataLbl.isHidden = true
        postCollectionView.isHidden = true
        postCollectionView.register(UINib.init(nibName:"TwoImgCVC" , bundle: nil), forCellWithReuseIdentifier: "TwoImgCVC")
        postCollectionView.register(UINib.init(nibName:"ThreeImgCVC" , bundle: nil), forCellWithReuseIdentifier: "ThreeImgCVC")
        postCollectionView.register(UINib.init(nibName:"FourImgCVC" , bundle: nil), forCellWithReuseIdentifier: "FourImgCVC")
        
        
        votedNoDataLbl.isHidden = true
        votedCollectionView.isHidden = true
        votedCollectionView.register(UINib.init(nibName:"TwoImgCVC" , bundle: nil), forCellWithReuseIdentifier: "TwoImgCVC")
        votedCollectionView.register(UINib.init(nibName:"ThreeImgCVC" , bundle: nil), forCellWithReuseIdentifier: "ThreeImgCVC")
        votedCollectionView.register(UINib.init(nibName:"FourImgCVC" , bundle: nil), forCellWithReuseIdentifier: "FourImgCVC")
        
        refreshProfilePost.addTarget(self, action: #selector(serviceCallToGetProfilePost), for: .valueChanged)
        postCollectionView.addSubview(refreshProfilePost)
        
        refreshVotedPost.addTarget(self, action: #selector(serviceCallToGetVotedPost), for: .valueChanged)
        votedCollectionView.addSubview(refreshVotedPost)
        
        
        clickToPosted(self)
    }
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        updateUserDetail()
    }
    
    @objc func updateUserDetail()
    {
        nameLbl.text = AppModel.shared.curruntUserDetail.userName
        APIManager.shared.serviceCallToGetProfileImage(AppModel.shared.curruntUserDetail.picture, [profileImg])
    }
    
    // MARK:- Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == postCollectionView {
            return profilePostList.count
        }
        else {
            return votedPostList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Wcell = (collectionView.frame.width / 3) - 3
        let Hcell = Wcell
        return CGSize(width: Wcell, height: Hcell)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var post : PostListModel = PostListModel.init()
        
        if collectionView == postCollectionView {
            post = profilePostList[indexPath.row]
            switch post.options.count {
            case 2:
                let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "TwoImgCVC", for: indexPath) as! TwoImgCVC
                
                if post.validOptions[0].percentage == 0 {
                    cell.lblBgView1.isHidden = true
                }
                else {
                    cell.lblBgView1.isHidden = false
                    cell.lbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                }
                
                if post.validOptions[1].percentage == 0 {
                    cell.lblBgView2.isHidden = true
                }
                else {
                    cell.lblBgView2.isHidden = false
                    cell.lbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                }
                
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
                return cell
            case 3:
                let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "ThreeImgCVC", for: indexPath) as! ThreeImgCVC
                
                if post.validOptions[0].percentage == 0 {
                    cell.lblBgView1.isHidden = true
                }
                else {
                    cell.lblBgView1.isHidden = false
                    cell.lbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                }
                
                if post.validOptions[1].percentage == 0 {
                    cell.lblBgView2.isHidden = true
                }
                else {
                    cell.lblBgView2.isHidden = false
                    cell.lbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                }
                
                if post.validOptions[2].percentage == 0 {
                    cell.lblBgView3.isHidden = true
                }
                else {
                    cell.lblBgView3.isHidden = false
                    cell.lbl3.text = String(Int(post.validOptions[2].percentage)) + "%"
                }
                
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[2].picture, [cell.img3])
                return cell
            case 4:
                let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "FourImgCVC", for: indexPath) as! FourImgCVC
                
                if post.validOptions[0].percentage == 0 {
                    cell.lblBgView1.isHidden = true
                }
                else {
                    cell.lblBgView1.isHidden = false
                    cell.lbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                }
                
                if post.validOptions[1].percentage == 0 {
                    cell.lblBgView2.isHidden = true
                }
                else {
                    cell.lblBgView2.isHidden = false
                    cell.lbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                }
                
                if post.validOptions[2].percentage == 0 {
                    cell.lblBgView3.isHidden = true
                }
                else {
                    cell.lblBgView3.isHidden = false
                    cell.lbl3.text = String(Int(post.validOptions[2].percentage)) + "%"
                }
                
                if post.validOptions[3].percentage == 0 {
                    cell.lblBgView4.isHidden = true
                }
                else {
                    cell.lblBgView4.isHidden = false
                    cell.lbl4.text = String(Int(post.validOptions[3].percentage)) + "%"
                }
                
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[2].picture, [cell.img3])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[3].picture, [cell.img4])
                return cell
            default:
                let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "TwoImgCVC", for: indexPath) as! TwoImgCVC
                return cell
            }
        }
        else
        {
            post = votedPostList[indexPath.row]
            switch post.options.count {
            case 2:
                let cell = votedCollectionView.dequeueReusableCell(withReuseIdentifier: "TwoImgCVC", for: indexPath) as! TwoImgCVC
                
                if post.validOptions[0].percentage == 0 {
                    cell.lblBgView1.isHidden = true
                }
                else {
                    cell.lblBgView1.isHidden = false
                    cell.lbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                }
                
                if post.validOptions[1].percentage == 0 {
                    cell.lblBgView2.isHidden = true
                }
                else {
                    cell.lblBgView2.isHidden = false
                    cell.lbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                }
                
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
                return cell
            case 3:
                let cell = votedCollectionView.dequeueReusableCell(withReuseIdentifier: "ThreeImgCVC", for: indexPath) as! ThreeImgCVC
                
                if post.validOptions[0].percentage == 0 {
                    cell.lblBgView1.isHidden = true
                }
                else {
                    cell.lblBgView1.isHidden = false
                    cell.lbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                }
                
                if post.validOptions[1].percentage == 0 {
                    cell.lblBgView2.isHidden = true
                }
                else {
                    cell.lblBgView2.isHidden = false
                    cell.lbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                }
                
                if post.validOptions[2].percentage == 0 {
                    cell.lblBgView3.isHidden = true
                }
                else {
                    cell.lblBgView3.isHidden = false
                    cell.lbl3.text = String(Int(post.validOptions[2].percentage)) + "%"
                }
                
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[2].picture, [cell.img3])
                return cell
            case 4:
                let cell = votedCollectionView.dequeueReusableCell(withReuseIdentifier: "FourImgCVC", for: indexPath) as! FourImgCVC
                
                if post.validOptions[0].percentage == 0 {
                    cell.lblBgView1.isHidden = true
                }
                else {
                    cell.lblBgView1.isHidden = false
                    cell.lbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                }
                
                if post.validOptions[1].percentage == 0 {
                    cell.lblBgView2.isHidden = true
                }
                else {
                    cell.lblBgView2.isHidden = false
                    cell.lbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                }
                
                if post.validOptions[2].percentage == 0 {
                    cell.lblBgView3.isHidden = true
                }
                else {
                    cell.lblBgView3.isHidden = false
                    cell.lbl3.text = String(Int(post.validOptions[2].percentage)) + "%"
                }
                
                if post.validOptions[3].percentage == 0 {
                    cell.lblBgView4.isHidden = true
                }
                else {
                    cell.lblBgView4.isHidden = false
                    cell.lbl4.text = String(Int(post.validOptions[3].percentage)) + "%"
                }
                
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[2].picture, [cell.img3])
                APIManager.shared.serviceCallToGetPostImage(post.validOptions[3].picture, [cell.img4])
                return cell
            default:
                let cell = votedCollectionView.dequeueReusableCell(withReuseIdentifier: "TwoImgCVC", for: indexPath) as! TwoImgCVC
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var post : PostListModel = PostListModel.init()
        
        if collectionView == postCollectionView {
            post = profilePostList[indexPath.row]
        }
        else
        {
            post = votedPostList[indexPath.row]
        }
        
        let vc:PostDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
        vc.curruntPost = post
        vc.imageFlag = post.options.count
        vc.headerFlag = headerFlag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == postCollectionView {
            if indexPath.row == (profilePostList.count-1) && isLoadNextUserPostData
            {
                serviceCallToGetProfilePost()
            }
        } else {
            if indexPath.row == (votedPostList.count-1) && isLoadNextVotedPostData
            {
                serviceCallToGetVotedPost()
            }
        }
        
    }
    
    // MARK:- Button Click
    @IBAction func clickToEditProfile(_ sender: Any) {
        self.view.endEditing(true)
        let vc : EditProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSetting(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SettingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToPosted(_ sender: Any) {
        self.view.endEditing(true)
        votedBackView.isHidden = true
        postedBackView.isHidden = false
        headerFlag = true
        postedBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        postedView.isHidden = false
        votedBtn.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.737254902, blue: 0.7098039216, alpha: 1), for: .normal)
        votedView.isHidden = true
        
        postCollectionView.isHidden = false
        votedCollectionView.isHidden = true
        refreshUserPostList()
    }
    
    @IBAction func clickToVoted(_ sender: Any) {
        self.view.endEditing(true)
        votedBackView.isHidden = false
        postedBackView.isHidden = true
        postCollectionView.isHidden = true
        votedCollectionView.isHidden = false
        headerFlag = false
        postedBtn.setTitleColor(#colorLiteral(red: 0.4980392157, green: 0.737254902, blue: 0.7098039216, alpha: 1), for: .normal)
        postedView.isHidden = true
        votedBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        votedView.isHidden = false
        refreshVotedPostList()
    }
    
    func refreshUserPostList() {
        userPostPage = 1
        userPostLimit = 30
        isLoadNextUserPostData = true
        serviceCallToGetProfilePost()
    }
    
    @objc func serviceCallToGetProfilePost()
    {
        refreshProfilePost.endRefreshing()
        let param : [String:Any] = ["profile": true, "polled": true, "page": userPostPage]
        
        APIManager.shared.serviceCallToUserPostList(param) { (data) in
            if self.userPostPage == 1
            {
                self.profilePostList = [PostListModel]()
            }
            
            for temp in data {
                self.profilePostList.append(PostListModel.init(dict: temp))
            }
            
            if data.count < self.userPostLimit
            {
                self.isLoadNextUserPostData = false
            } else{
                self.userPostPage += 1
            }
            
            if self.profilePostList.count == 0 {
                self.postedNoDataLbl.isHidden = false
                self.postCollectionView.isHidden = true
            }
            else {
                self.postedNoDataLbl.isHidden = true
                self.postCollectionView.isHidden = false
                self.postCollectionView.reloadData()
            }
        }
    }
    
    func refreshVotedPostList() {
        votedPostPage = 1
        votedPostLimit = 30
        isLoadNextVotedPostData = true
        serviceCallToGetVotedPost()
    }
    
    @objc func serviceCallToGetVotedPost()
    {
        refreshVotedPost.endRefreshing()
        let param : [String: Any] = ["polled": true, "page": votedPostPage]
        APIManager.shared.serviceCallToUserVotedPostList(param) { (data) in
            if self.votedPostPage == 1
            {
                self.votedPostList = [PostListModel]()
            }
            
            for temp in data {
                self.votedPostList.append(PostListModel.init(dict: temp))
            }
            
            if data.count < self.votedPostLimit
            {
                self.isLoadNextVotedPostData = false
            } else{
                self.votedPostPage += 1
            }
            
            if self.votedPostList.count == 0 {
                self.votedNoDataLbl.isHidden = false
                self.votedCollectionView.isHidden = true
            }
            else {
                self.votedNoDataLbl.isHidden = true
                self.votedCollectionView.isHidden = false
                self.votedCollectionView.reloadData()
                self.votedCollectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
