//
//  CommentVC.swift
//  Wishbone Like App
//
//  Created by PC on 03/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class CommentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var commentTblView: UITableView!
    @IBOutlet var twoImageHeaderView: UIView!
    @IBOutlet var threeImageHeaderView: UIView!
    @IBOutlet var fourImageHeaderView: UIView!
    
    @IBOutlet weak var twoImg1: UIImageView!
    @IBOutlet weak var twoImg2: UIImageView!
    
    @IBOutlet weak var threeImg1: UIImageView!
    @IBOutlet weak var threeImg2: UIImageView!
    @IBOutlet weak var threeImg3: UIImageView!
    
    @IBOutlet weak var fourImg1: UIImageView!
    @IBOutlet weak var fourImg2: UIImageView!
    @IBOutlet weak var fourImg3: UIImageView!
    @IBOutlet weak var fourImg4: UIImageView!
    
    @IBOutlet weak var twoImageProgressBackView1: UIView!
    @IBOutlet weak var twoImageProgressView1: CircleProgressView!
    @IBOutlet weak var twoImageProgressLbl1: Label!
    @IBOutlet weak var twoImageProgressBackView2: UIView!
    @IBOutlet weak var twoImageProgressView2: CircleProgressView!
    @IBOutlet weak var twoImageProgressLbl2: Label!
    
    @IBOutlet weak var threeImageProgressBackView1: UIView!
    @IBOutlet weak var threeImageProgressView1: CircleProgressView!
    @IBOutlet weak var threeImageProgressLbl1: Label!
    @IBOutlet weak var threeImageProgressBackView2: UIView!
    @IBOutlet weak var threeImageProgressView2: CircleProgressView!
    @IBOutlet weak var threeImageProgressLbl2: Label!
    @IBOutlet weak var threeImageProgressBackView3: UIView!
    @IBOutlet weak var threeImageProgressView3: CircleProgressView!
    @IBOutlet weak var threeImageProgressLbl3: Label!
    
    @IBOutlet weak var fourImageProgressBackView1: UIView!
    @IBOutlet weak var fourImageProgressView1: CircleProgressView!
    @IBOutlet weak var fourImageProgressLbl1: Label!
    @IBOutlet weak var fourImageProgressBackView2: UIView!
    @IBOutlet weak var fourImageProgressView2: CircleProgressView!
    @IBOutlet weak var fourImageProgressLbl2: Label!
    @IBOutlet weak var fourImageProgressBackView3: UIView!
    @IBOutlet weak var fourImageProgressView3: CircleProgressView!
    @IBOutlet weak var fourImageProgressLbl3: Label!
    @IBOutlet weak var fourImageProgressBackView4: UIView!
    @IBOutlet weak var fourImageProgressView4: CircleProgressView!
    @IBOutlet weak var fourImageProgressLbl4: Label!
    
    @IBOutlet weak var twoImgCaptionLbl1: Label!
    @IBOutlet weak var twoImgCaptionLbl2: Label!
    
    @IBOutlet weak var threeImgCaptionLbl1: Label!
    @IBOutlet weak var threeImgCaptionLbl2: Label!
    @IBOutlet weak var threeImgCaptionLbl3: Label!
    
    @IBOutlet weak var fourImgCaptionLbl1: Label!
    @IBOutlet weak var fourImgCaptionLbl2: Label!
    @IBOutlet weak var fourImgCaptionLbl3: Label!
    @IBOutlet weak var fourImgCaptionLbl4: Label!
    
    @IBOutlet weak var commentTxt: TextField!
    
    var curruntImgHeader:Int = 0
    var curruntPost:PostListModel = PostListModel.init()
    var commentListData:[CommentModel] = [CommentModel]()
    
    var page = 1
    var limit = 30
    var isLoadNextData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTblView.register(UINib.init(nibName: "CommentTVC", bundle: nil), forCellReuseIdentifier: "CommentTVC")
        refreshCommentList()
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
        return commentListData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 360
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 180))
        switch curruntImgHeader {
        case 2:
            
            if curruntPost.isPolled {
                twoImageProgressBackView1.isHidden = false
                twoImageProgressView1.progress = Double(curruntPost.validOptions[0].percentage) / 100
                twoImageProgressLbl1.text = String(Int(curruntPost.validOptions[0].percentage)) + "%"
                twoImageProgressBackView2.isHidden = false
                twoImageProgressView2.progress = Double(curruntPost.validOptions[1].percentage) / 100
                twoImageProgressLbl2.text = String(Int(curruntPost.validOptions[1].percentage)) + "%"
            } else {
                twoImageProgressBackView1.isHidden = true
                twoImageProgressBackView2.isHidden = true
            }
            
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[0].picture, [twoImg1])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[1].picture, [twoImg2])
            
            twoImgCaptionLbl1.text = curruntPost.validOptions[0].caption
            twoImgCaptionLbl2.text = curruntPost.validOptions[1].caption
            
            displaySubViewtoParentView(view, subview: twoImageHeaderView)
            break
        case 3:
            
            if curruntPost.isPolled {
                threeImageProgressBackView1.isHidden = false
                threeImageProgressView1.progress = Double(curruntPost.validOptions[0].percentage) / 100
                fourImageProgressLbl1.text = String(Int(curruntPost.validOptions[0].percentage)) + "%"
                threeImageProgressBackView2.isHidden = false
                threeImageProgressView2.progress = Double(curruntPost.validOptions[1].percentage) / 100
                threeImageProgressLbl2.text = String(Int(curruntPost.validOptions[1].percentage)) + "%"
                threeImageProgressBackView3.isHidden = false
                threeImageProgressView3.progress = Double(curruntPost.validOptions[2].percentage) / 100
                threeImageProgressLbl3.text = String(Int(curruntPost.validOptions[2].percentage)) + "%"
            } else {
                threeImageProgressBackView1.isHidden = true
                threeImageProgressBackView2.isHidden = true
                threeImageProgressBackView3.isHidden = true
            }
            
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[0].picture, [threeImg1])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[1].picture, [threeImg2])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[2].picture, [threeImg3])
            
            threeImgCaptionLbl1.text = curruntPost.validOptions[0].caption
            threeImgCaptionLbl2.text = curruntPost.validOptions[1].caption
            threeImgCaptionLbl3.text = curruntPost.validOptions[2].caption
            
            displaySubViewtoParentView(view, subview: threeImageHeaderView)
            break
        case 4:
            
            if curruntPost.isPolled {
                fourImageProgressBackView1.isHidden = false
                fourImageProgressView1.progress = Double(curruntPost.validOptions[0].percentage) / 100
                fourImageProgressLbl1.text = String(Int(curruntPost.validOptions[0].percentage)) + "%"
                fourImageProgressBackView2.isHidden = false
                fourImageProgressView2.progress = Double(curruntPost.validOptions[1].percentage) / 100
                fourImageProgressLbl2.text = String(Int(curruntPost.validOptions[1].percentage)) + "%"
                fourImageProgressBackView3.isHidden = false
                fourImageProgressView3.progress = Double(curruntPost.validOptions[2].percentage) / 100
                fourImageProgressLbl3.text = String(Int(curruntPost.validOptions[2].percentage)) + "%"
                fourImageProgressBackView4.isHidden = false
                fourImageProgressView4.progress = Double(curruntPost.validOptions[3].percentage) / 100
                fourImageProgressLbl4.text = String(Int(curruntPost.validOptions[3].percentage)) + "%"
            } else {
                fourImageProgressBackView1.isHidden = true
                fourImageProgressBackView2.isHidden = true
                fourImageProgressBackView3.isHidden = true
                fourImageProgressBackView4.isHidden = true
            }
            
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[0].picture, [fourImg1])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[1].picture, [fourImg2])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[2].picture, [fourImg3])
            APIManager.shared.serviceCallToGetPostImage(curruntPost.validOptions[3].picture, [fourImg4])
            
            fourImgCaptionLbl1.text = curruntPost.validOptions[0].caption
            fourImgCaptionLbl2.text = curruntPost.validOptions[1].caption
            fourImgCaptionLbl3.text = curruntPost.validOptions[2].caption
            fourImgCaptionLbl4.text = curruntPost.validOptions[3].caption
            
            displaySubViewtoParentView(view, subview: fourImageHeaderView)
            
            break
        default:
            break
        }
        self.view.addSubview(view)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTblView.dequeueReusableCell(withIdentifier: "CommentTVC", for: indexPath) as! CommentTVC
        APIManager.shared.serviceCallToGetProfileImage(commentListData[indexPath.row].user.picture, [cell.profileBtn])
        cell.name.text = commentListData[indexPath.row].user.userName
        cell.comment.text = commentListData[indexPath.row].content
        cell.dateTime.text = returnDateTimeInString(commentListData[indexPath.row].date)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (commentListData.count-1) && isLoadNextData
        {
            refreshCommentList()
        }
    }
    
    // MARK:- Methods
    func refreshCommentList() {
        page = 1
        limit = 30
        isLoadNextData = true
        reloadComments()
    }
    
    func reloadComments() {
        let param:[String:Any] = ["postId":curruntPost._id!, "page" : page]
        APIManager.shared.serviceCallToCommentList(param) { (data) in
            
            if self.page == 1
            {
                self.commentListData = [CommentModel]()
            }
            
            for temp in data {
               self.commentListData.append(CommentModel.init(dict: temp))
            }
            
            if data.count < self.limit
            {
                self.isLoadNextData = false
            } else {
                self.page += 1
            }
            
            if self.commentListData.count == 0 {
                
            } else {
                self.commentTblView.reloadData()
            }
        }
        
    }
    
    // MARK:- Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToShowImage(_ sender: UIButton) {
        /*
        // display Image
        let url = GET_IMAGE_URL.POST + curruntPost.validOptions[sender.tag].picture
        displayFullImage([url], 0)
        */
        
        if curruntPost.isPolled {
            displayToast("You already voted this feed.")
        } else {
            let param: [String:Any] = ["postId": curruntPost._id!,
                                       "optionId": curruntPost.validOptions[sender.tag]._id!]
            APIManager.shared.serviceCallToVote(param) {
                
                let post : PostListModel = self.curruntPost
                post.isPolled = true
                post.validOptions[sender.tag].total = post.validOptions[sender.tag].total + 1
                post.totalVote = post.totalVote + 1
                
                for i in 0..<post.validOptions.count
                {
                    post.validOptions[i].percentage = Float(post.validOptions[i].total * 100 / post.totalVote)
                }
                self.curruntPost = post
                self.commentTblView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_POST_DATA), object: ["post" : self.curruntPost.dictionary()])
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_USET_POST_DATA), object: ["post" : self.curruntPost.dictionary()])
            }
        }
    }
    
    @IBAction func clickToFeed(_ sender: UIButton) {
        self.view.endEditing(true)
        switch sender.tag {
        case 1:
            print(sender.tag)
            break
        case 2:
            print(sender.tag)
            break
        case 3:
            print(sender.tag)
            break
        case 4:
            print(sender.tag)
            break
        case 5:
            print(sender.tag)
            break
        case 6:
            print(sender.tag)
            break
        case 7:
            print(sender.tag)
            break
        case 8:
            print(sender.tag)
            break
        case 9:
            print(sender.tag)
            break
        default:
            break
        }
    }
    
    @IBAction func clickToPost(_ sender: Any) {
        self.view.endEditing(true)
        if commentTxt.text?.trimmed.count == 0 {
            commentTxt.text = ""
            displayToast("Enter comment")
        } else {
            var param:[String:Any] = [String:Any]()
            param["postId"] = curruntPost._id
            param["comment"] = commentTxt.text!.trimmed
            APIManager.shared.serviceCallToCreateComment(param) {
                self.refreshCommentList()
                self.curruntPost.comments = self.curruntPost.comments + 1
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_POST_DATA), object: ["post" : self.curruntPost.dictionary()])
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_USET_POST_DATA), object: ["post" : self.curruntPost.dictionary()])
            }
            commentTxt.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
