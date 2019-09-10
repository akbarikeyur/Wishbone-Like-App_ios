//
//  FourImgTVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class FourImgTVC: UITableViewCell {
    
    @IBOutlet weak var profileBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var detailLbl: Label!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var findBtn1: Button!
    @IBOutlet weak var findBtn2: Button!
    @IBOutlet weak var findBtn3: Button!
    @IBOutlet weak var findBtn4: Button!
    @IBOutlet weak var voteBtn: Button!
    @IBOutlet weak var commentBtn: Button!
    @IBOutlet weak var progressBackView1: UIView!
    @IBOutlet weak var progressView1: CircleProgressView!
    @IBOutlet weak var progressLbl1: Label!
    @IBOutlet weak var progressBackView2: UIView!
    @IBOutlet weak var progressView2: CircleProgressView!
    @IBOutlet weak var progressLbl2: Label!
    @IBOutlet weak var progressBackView3: UIView!
    @IBOutlet weak var progressView3: CircleProgressView!
    @IBOutlet weak var progressLbl3: Label!
    @IBOutlet weak var progressBackView4: UIView!
    @IBOutlet weak var progressView4: CircleProgressView!
    @IBOutlet weak var progressLbl4: Label!
    @IBOutlet weak var showImgBtn1: Button!
    @IBOutlet weak var showImgBtn2: Button!
    @IBOutlet weak var showImgBtn3: Button!
    @IBOutlet weak var showImgBtn4: Button!
    @IBOutlet weak var captionLbl1: Label!
    @IBOutlet weak var captionLbl2: Label!
    @IBOutlet weak var captionLbl3: Label!
    @IBOutlet weak var captionLbl4: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
