//
//  CommentTVC.swift
//  Wishbone Like App
//
//  Created by PC on 03/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class CommentTVC: UITableViewCell {

    @IBOutlet weak var profileBtn: Button!
    @IBOutlet weak var name: Label!
    @IBOutlet weak var dateTime: Label!
    @IBOutlet weak var comment: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
