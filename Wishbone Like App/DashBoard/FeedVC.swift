//
//  FeedVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var noDataLbl: Label!

    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var allPostData : [PostListModel] = [PostListModel]()
    var page = 1
    var limit = 10
    var isLoadNextData = true
    var selectedIndex = 0
    var isAPIcalling : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDataLbl.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostList), name: NSNotification.Name.init(NOTIFICATION.GET_ALL_POPST), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePostData(noti:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_POST_DATA), object: nil)
        
        
        feedTableView.register(UINib.init(nibName: "TwoImgTVC", bundle: nil), forCellReuseIdentifier: "TwoImgTVC")
        feedTableView.register(UINib.init(nibName: "ThreeImgTVC", bundle: nil), forCellReuseIdentifier: "ThreeImgTVC")
        feedTableView.register(UINib.init(nibName: "FourImgTVC", bundle: nil), forCellReuseIdentifier: "FourImgTVC")
        
        // Refresh Table View
        refreshControl.tintColor = AppColor
        refreshControl.addTarget(self, action: #selector(refreshPostList), for: .valueChanged)
        if #available(iOS 10.0, *) {
            feedTableView.refreshControl = refreshControl
        } else {
            feedTableView.addSubview(refreshControl)
        }
        
        refreshPostList()
    }
    
    @objc func updatePostData(noti : Notification) {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let tempDict : [String : Any] = dict["post"] as? [String : Any]
            {
                let post : PostListModel = PostListModel.init(dict: tempDict)
                
                let index = allPostData.index { (temp) -> Bool in
                    temp._id == post._id
                }
                if index != nil
                {
                    allPostData[index!] = post
                    feedTableView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: UITableViewRowAnimation.none)
                }
            }
        }
    }
    
    @objc func refreshPostList() {
        page = 1
        limit = 10
        isLoadNextData = true
        dataSetup()
    }
    
    @objc func dataSetup() {
        refreshControl.endRefreshing()
        
        if isAPIcalling {
            return
        }
        isAPIcalling = true
        let param : [String : Any] = ["page" : page, "limit" : limit, "profile": false, "polled": false]
        
        APIManager.shared.serviceCallToAllPost(param) { (data) in
            if self.page == 1
            {
                self.allPostData = [PostListModel]()
                self.feedTableView.reloadData()
            }
            
            for temp in data {
                self.allPostData.append(PostListModel.init(dict: temp))
            }
            if self.allPostData.count == 0 {
                self.feedTableView.isHidden = true
                self.noDataLbl.isHidden = false
            } else {
                self.feedTableView.isHidden = false
                self.noDataLbl.isHidden = true
                self.feedTableView.reloadData()
            }
            if data.count < self.limit
            {
                self.isLoadNextData = false
            } else {
                self.page += 1
            }
            delay(1.0, closure: {
                self.isAPIcalling = false
            })
            
        }
    }
    
    //MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: false)
            // tabBar.headerView.isHidden = true
        }
    }
    
    // MARK:- Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPostData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = allPostData[indexPath.row]
        
        switch post.options.count {
        case 2:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "TwoImgTVC", for: indexPath) as! TwoImgTVC
            cell.profileBtn.setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
            APIManager.shared.serviceCallToGetProfileImage(post.user.picture, [cell.profileBtn])
            
            cell.namelbl.text = post.user.userName
            cell.detailLbl.text = post.content
            if post.isPolled {
                cell.progressBackView1.isHidden = false
                cell.progressView1.progress = Double(post.validOptions[0].percentage) / 100
                cell.progressLbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                cell.progressBackView2.isHidden = false
                cell.progressView2.progress = Double(post.validOptions[1].percentage) / 100
                cell.progressLbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
            } else {
                cell.progressBackView1.isHidden = true
                cell.progressBackView2.isHidden = true
            }
            
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
            cell.captionLbl1.text = post.validOptions[0].caption
            cell.captionLbl2.text = post.validOptions[1].caption
            
            cell.showImgBtn1.tag = indexPath.row
            cell.showImgBtn1.index = 0
            cell.showImgBtn1.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn2.tag = indexPath.row
            cell.showImgBtn2.index = 1
            cell.showImgBtn2.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            
            cell.findBtn1.tag = indexPath.row
            cell.findBtn1.index = 0
            cell.findBtn1.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            cell.findBtn2.tag = indexPath.row
            cell.findBtn2.index = 1
            cell.findBtn2.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            
            cell.voteBtn.setTitle("\(post.totalVote!) Votes", for: .normal)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.setTitle("\(post.comments!) Comments", for: .normal)
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            
            
            cell.layoutIfNeeded()
            return cell
        case 3:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "ThreeImgTVC", for: indexPath) as! ThreeImgTVC
            cell.profileBtn.setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
            APIManager.shared.serviceCallToGetProfileImage(post.user.picture, [cell.profileBtn])
            cell.nameLbl.text = post.user.userName
            cell.detailLbl.text = post.content
            
            if post.isPolled {
                cell.progressBackView1.isHidden = false
                cell.progressView1.progress = Double(post.validOptions[0].percentage) / 100
                cell.progressLbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                cell.progressBackView2.isHidden = false
                cell.progressView2.progress = Double(post.validOptions[1].percentage) / 100
                cell.progressLbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                cell.progressBackView3.isHidden = false
                cell.progressView3.progress = Double(post.validOptions[2].percentage) / 100
                cell.progressLbl3.text = String(Int(post.validOptions[2].percentage)) + "%"
            } else {
                cell.progressBackView1.isHidden = true
                cell.progressBackView2.isHidden = true
                cell.progressBackView3.isHidden = true
            }
            
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[2].picture, [cell.img3])
            
            cell.captionLbl1.text = post.validOptions[0].caption
            cell.captionLbl2.text = post.validOptions[1].caption
            cell.captionLbl3.text = post.validOptions[2].caption
            
            cell.showImgBtn1.tag = indexPath.row
            cell.showImgBtn1.index = 0
            cell.showImgBtn1.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn2.tag = indexPath.row
            cell.showImgBtn2.index = 1
            cell.showImgBtn2.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn3.tag = indexPath.row
            cell.showImgBtn3.index = 2
            cell.showImgBtn3.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            
            cell.findBtn1.tag = indexPath.row
            cell.findBtn1.index = 0
            cell.findBtn1.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            cell.findBtn2.tag = indexPath.row
            cell.findBtn2.index = 1
            cell.findBtn2.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            cell.findBtn3.tag = indexPath.row
            cell.findBtn3.index = 2
            cell.findBtn3.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            
            cell.voteBtn.setTitle("\(post.totalVote!) Votes", for: .normal)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.setTitle("\(post.comments!) Comments", for: .normal)
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            return cell
        case 4:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "FourImgTVC", for: indexPath) as! FourImgTVC
            cell.profileBtn.setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
            APIManager.shared.serviceCallToGetProfileImage(post.user.picture, [cell.profileBtn])
            cell.nameLbl.text = post.user.userName
            cell.detailLbl.text = post.content
            
            if post.isPolled {
                cell.progressBackView1.isHidden = false
                cell.progressView1.progress = Double(post.validOptions[0].percentage) / 100
                cell.progressLbl1.text = String(Int(post.validOptions[0].percentage)) + "%"
                cell.progressBackView2.isHidden = false
                cell.progressView2.progress = Double(post.validOptions[1].percentage) / 100
                cell.progressLbl2.text = String(Int(post.validOptions[1].percentage)) + "%"
                cell.progressBackView3.isHidden = false
                cell.progressView3.progress = Double(post.validOptions[2].percentage) / 100
                cell.progressLbl3.text = String(Int(post.validOptions[2].percentage)) + "%"
                cell.progressBackView4.isHidden = false
                cell.progressView4.progress = Double(post.validOptions[3].percentage) / 100
                cell.progressLbl4.text = String(Int(post.validOptions[3].percentage)) + "%"
            } else {
                cell.progressBackView1.isHidden = true
                cell.progressBackView2.isHidden = true
                cell.progressBackView3.isHidden = true
                cell.progressBackView4.isHidden = true
            }
            
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[0].picture, [cell.img1])
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[1].picture, [cell.img2])
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[2].picture, [cell.img3])
            APIManager.shared.serviceCallToGetPostImage(post.validOptions[3].picture, [cell.img4])
            
            cell.captionLbl1.text = post.validOptions[0].caption
            cell.captionLbl2.text = post.validOptions[1].caption
            cell.captionLbl3.text = post.validOptions[2].caption
            cell.captionLbl4.text = post.validOptions[3].caption
            
            cell.showImgBtn1.tag = indexPath.row
            cell.showImgBtn1.index = 0
            cell.showImgBtn1.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn2.tag = indexPath.row
            cell.showImgBtn2.index = 1
            cell.showImgBtn2.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn3.tag = indexPath.row
            cell.showImgBtn3.index = 2
            cell.showImgBtn3.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            cell.showImgBtn4.tag = indexPath.row
            cell.showImgBtn4.index = 3
            cell.showImgBtn4.addTarget(self, action: #selector(clickToShowImage), for: .touchUpInside)
            
            cell.findBtn1.tag = indexPath.row
            cell.findBtn1.index = 0
            cell.findBtn1.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            cell.findBtn2.tag = indexPath.row
            cell.findBtn2.index = 1
            cell.findBtn2.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            cell.findBtn3.tag = indexPath.row
            cell.findBtn3.index = 2
            cell.findBtn3.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            cell.findBtn4.tag = indexPath.row
            cell.findBtn4.index = 3
            cell.findBtn4.addTarget(self, action: #selector(clickToFind), for: .touchUpInside)
            
            cell.voteBtn.setTitle("\(post.totalVote!) Votes", for: .normal)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.setTitle("\(post.comments!) Comments", for: .normal)
            cell.commentBtn.addTarget(self, action: #selector(clickToComment), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            return cell
        default:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "FourImgTVC", for: indexPath) as! FourImgTVC
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedTableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (allPostData.count-5) == indexPath.row && isLoadNextData {
            dataSetup()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedTableView.frame.size.height
    }
    
    //MARK:- Methods
    @objc func clickToComment(sender: UIButton) {
        self.view.endEditing(true)
        selectedIndex = sender.tag
        let vc:CommentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        vc.curruntPost = allPostData[sender.tag]
        vc.curruntImgHeader = allPostData[sender.tag].options.count
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToShowImage(_ sender : Button) {
        /*
        // Display Image
        let url = GET_IMAGE_URL.POST + allPostData[sender.tag].validOptions[sender.index].picture
        displayFullImage([url], 0)
        */
        
        if allPostData[sender.tag].isPolled {
            displayToast("You already voted this feed.")
        } else {
            let param: [String:Any] = ["postId": allPostData[sender.tag]._id!,
                                       "optionId": allPostData[sender.tag].validOptions[sender.index]._id!]
            APIManager.shared.serviceCallToVote(param) {
                
                let post : PostListModel = self.allPostData[sender.tag]
                post.isPolled = true
                post.validOptions[sender.index].total = post.validOptions[sender.index].total + 1
                post.totalVote = post.totalVote + 1
                
                for i in 0..<post.validOptions.count
                {
                    post.validOptions[i].percentage = Float(Double((Double(post.validOptions[i].total) * 100) / Double(post.totalVote)))
                }
                self.allPostData[sender.tag] = post

                let indexPath:IndexPath = IndexPath(row: sender.tag, section: 0)
                self.feedTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
        }
    }
    
    @objc func clickToFind(_ sender: Button) {
        if allPostData[sender.tag].validOptions[sender.index].url != "" {
            openUrlInSafari(strUrl: allPostData[sender.tag].validOptions[sender.index].url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
