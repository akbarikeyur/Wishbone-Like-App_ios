//
//  PostDetailVC.swift
//  Wishbone Like App
//
//  Created by PC on 10/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class PostDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postTbl: UITableView!
    @IBOutlet weak var headerLbl: Label!
    
    var headerFlag:Bool = true
    var imageFlag:Int = 0
    var curruntPost:PostListModel = PostListModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updatePostData(noti:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_USET_POST_DATA), object: nil)
        
        postTbl.register(UINib.init(nibName: "TwoImgTVC", bundle: nil), forCellReuseIdentifier: "TwoImgTVC")
        postTbl.register(UINib.init(nibName: "ThreeImgTVC", bundle: nil), forCellReuseIdentifier: "ThreeImgTVC")
        postTbl.register(UINib.init(nibName: "FourImgTVC", bundle: nil), forCellReuseIdentifier: "FourImgTVC")
        
        if headerFlag {
            headerLbl.text = "My Post"
        } else {
            headerLbl.text = "My Vote"
        }
    }
    
    @objc func updatePostData(noti : Notification) {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let tempDict : [String : Any] = dict["post"] as? [String : Any]
            {
                let post : PostListModel = PostListModel.init(dict: tempDict)
                curruntPost = post
                postTbl.reloadData()
            }
        }
    }
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    // MARK:- Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return postTbl.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch imageFlag {
        case 2:
            let cell = postTbl.dequeueReusableCell(withIdentifier: "TwoImgTVC", for: indexPath) as! TwoImgTVC
            cell.selectionStyle = .none
            cell.profileBtn.setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
            APIManager.shared.serviceCallToGetProfileImage(curruntPost.user.picture, [cell.profileBtn])
            cell.namelbl.text = curruntPost.user.userName
            cell.detailLbl.text = curruntPost.content
            
            if curruntPost.isPolled {
                cell.progressBackView1.isHidden = false
                cell.progressView1.progress = Double(curruntPost.validOptions[0].percentage) / 100
                cell.progressLbl1.text = String(Int(curruntPost.validOptions[0].percentage)) + "%"
                cell.progressBackView2.isHidden = false
                cell.progressView2.progress = Double(curruntPost.validOptions[1].percentage) / 100
                cell.progressLbl2.text = String(Int(curruntPost.validOptions[1].percentage)) + "%"
            } else {
                cell.progressBackView1.isHidden = true
                cell.progressBackView2.isHidden = true
            }
            
            cell.captionLbl1.text = curruntPost.validOptions[0].caption
            cell.captionLbl2.text = curruntPost.validOptions[1].caption
            
            cell.showImgBtn1.tag = 0
            cell.showImgBtn1.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn2.tag = 1
            cell.showImgBtn2.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            
            cell.voteBtn.setTitle("\(curruntPost.totalVote!) Votes", for: .normal)
            cell.commentBtn.setTitle("\(curruntPost.comments!) Comments", for: .normal)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[0].picture, [cell.img1])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[1].picture, [cell.img2])
            
            return cell
        case 3:
            let cell = postTbl.dequeueReusableCell(withIdentifier: "ThreeImgTVC", for: indexPath) as! ThreeImgTVC
            cell.selectionStyle = .none
            cell.profileBtn.setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
            APIManager.shared.serviceCallToGetProfileImage(curruntPost.user.picture, [cell.profileBtn])
            cell.nameLbl.text = curruntPost.user.userName
            cell.detailLbl.text = curruntPost.content
            
            if curruntPost.isPolled {
                cell.progressBackView1.isHidden = false
                cell.progressView1.progress = Double(curruntPost.validOptions[0].percentage) / 100
                cell.progressLbl1.text = String(Int(curruntPost.validOptions[0].percentage)) + "%"
                cell.progressBackView2.isHidden = false
                cell.progressView2.progress = Double(curruntPost.validOptions[1].percentage) / 100
                cell.progressLbl2.text = String(Int(curruntPost.validOptions[1].percentage)) + "%"
                cell.progressBackView3.isHidden = false
                cell.progressView3.progress = Double(curruntPost.validOptions[2].percentage) / 100
                cell.progressLbl3.text = String(Int(curruntPost.validOptions[2].percentage)) + "%"
            } else {
                cell.progressBackView1.isHidden = true
                cell.progressBackView2.isHidden = true
                cell.progressBackView3.isHidden = true
            }
            
            cell.showImgBtn1.tag = 0
            cell.showImgBtn1.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn2.tag = 1
            cell.showImgBtn2.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn3.tag = 2
            cell.showImgBtn3.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            
            cell.voteBtn.setTitle("\(curruntPost.totalVote!) Votes", for: .normal)
            cell.commentBtn.setTitle("\(curruntPost.comments!) Comments", for: .normal)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[0].picture, [cell.img1])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[1].picture, [cell.img2])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[2].picture, [cell.img3])
            
            cell.captionLbl1.text = curruntPost.validOptions[0].caption
            cell.captionLbl2.text = curruntPost.validOptions[1].caption
            cell.captionLbl3.text = curruntPost.validOptions[2].caption
            return cell
        case 4:
            let cell = postTbl.dequeueReusableCell(withIdentifier: "FourImgTVC", for: indexPath) as! FourImgTVC
            cell.selectionStyle = .none
            cell.profileBtn.setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
            APIManager.shared.serviceCallToGetProfileImage(curruntPost.user.picture, [cell.profileBtn])
            cell.nameLbl.text = curruntPost.user.userName
            cell.detailLbl.text = curruntPost.content
            
            if curruntPost.isPolled {
                cell.progressBackView1.isHidden = false
                cell.progressView1.progress = Double(curruntPost.validOptions[0].percentage) / 100
                cell.progressLbl1.text = String(Int(curruntPost.validOptions[0].percentage)) + "%"
                cell.progressBackView2.isHidden = false
                cell.progressView2.progress = Double(curruntPost.validOptions[1].percentage) / 100
                cell.progressLbl2.text = String(Int(curruntPost.validOptions[1].percentage)) + "%"
                cell.progressBackView3.isHidden = false
                cell.progressView3.progress = Double(curruntPost.validOptions[2].percentage) / 100
                cell.progressLbl3.text = String(Int(curruntPost.validOptions[2].percentage)) + "%"
                cell.progressBackView4.isHidden = false
                cell.progressView4.progress = Double(curruntPost.validOptions[3].percentage) / 100
                cell.progressLbl4.text = String(Int(curruntPost.validOptions[3].percentage)) + "%"
            } else {
                cell.progressBackView1.isHidden = true
                cell.progressBackView2.isHidden = true
                cell.progressBackView3.isHidden = true
                cell.progressBackView4.isHidden = true
            }
            
            cell.showImgBtn1.tag = 0
            cell.showImgBtn1.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn2.tag = 1
            cell.showImgBtn2.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn3.tag = 2
            cell.showImgBtn3.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn4.tag = 3
            cell.showImgBtn4.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            
            cell.voteBtn.setTitle("\(curruntPost.totalVote!) Votes", for: .normal)
            cell.commentBtn.setTitle("\(curruntPost.comments!) Comments", for: .normal)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[0].picture, [cell.img1])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[1].picture, [cell.img2])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[2].picture, [cell.img3])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[3].picture, [cell.img4])
            
            cell.captionLbl1.text = curruntPost.validOptions[0].caption
            cell.captionLbl2.text = curruntPost.validOptions[1].caption
            cell.captionLbl3.text = curruntPost.validOptions[2].caption
            cell.captionLbl4.text = curruntPost.validOptions[3].caption
            
            return cell
        default:
            let cell = postTbl.dequeueReusableCell(withIdentifier: "TwoImgTVC", for: indexPath) as! ThreeImgTVC
            cell.selectionStyle = .none
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            return cell
        }
    }

    // MARK:- Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Methods
    @objc func clickToComment(sender : UIButton) {
        self.view.endEditing(true)
        let vc:CommentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        vc.curruntImgHeader = curruntPost.options.count
        vc.curruntPost = curruntPost
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToShowImage(_ sender : Button) {
        let url = GET_IMAGE_URL.POST + curruntPost.validOptions[sender.tag].picture
        displayFullImage([url], 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
