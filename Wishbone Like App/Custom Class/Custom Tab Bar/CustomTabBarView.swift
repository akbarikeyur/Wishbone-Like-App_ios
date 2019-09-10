//
//  CustomTabBarView.swift
//  Event Project
//
//  Created by Amisha on 20/07/17.
//  Copyright © 2017 AK Infotech. All rights reserved.
//

import UIKit

protocol CustomTabBarViewDelegate
{
    func tabSelectedAtIndex(index:Int)
}

class CustomTabBarView: UIView {

    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var img1: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    var delegate:CustomTabBarViewDelegate?
    var lastIndex : NSInteger!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        resetAllButton()
        img1.isHidden = false
    }
    
    func initialize()
    {
        lastIndex = 0
        
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize(width: 1, height: -0.5)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
    }
    
    @IBAction func tabBtnClicked(_ sender: UIButton)
    {
        let btn: UIButton = sender
        lastIndex = btn.tag - 1

        resetAllButton()
        selectTabButton()
    }

    func resetAllButton()
    {
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
        
        img1.isHidden = true
        img3.isHidden = true
    }
    
    func selectTabButton()
    {
        switch lastIndex {
        case 0:
            btn1.isSelected = true
            img1.isHidden = false
            break
        case 1:
            btn2.isSelected = true
            break
        case 2:
            btn3.isSelected = true
            img3.isHidden = false
            break
        default:
            break
        }
        delegate?.tabSelectedAtIndex(index: lastIndex)
    }
}
