//
//  TwoImgTVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class TwoImgTVC: UITableViewCell {
    
    @IBOutlet weak var profileBtn: Button!
    @IBOutlet weak var namelbl: Label!
    @IBOutlet weak var detailLbl: Label!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var findBtn1: Button!
    @IBOutlet weak var findBtn2: Button!
    @IBOutlet weak var voteBtn: Button!
    @IBOutlet weak var commentBtn: Button!
    @IBOutlet weak var progressBackView1: UIView!
    @IBOutlet weak var progressView1: CircleProgressView!
    @IBOutlet weak var progressLbl1: Label!
    @IBOutlet weak var progressBackView2: UIView!
    @IBOutlet weak var progressView2: CircleProgressView!
    @IBOutlet weak var progressLbl2: Label!
    @IBOutlet weak var showImgBtn1: Button!
    @IBOutlet weak var showImgBtn2: Button!
    @IBOutlet weak var captionLbl1: Label!
    @IBOutlet weak var captionLbl2: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
