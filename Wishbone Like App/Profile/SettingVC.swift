//
//  SettingVC.swift
//  Wishbone Like App
//
//  Created by PC on 30/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTbl: UITableView!
    
    let settingArr = ["About Us", "Contact Us", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            tabBar.setTabBarHidden(tabBarHidden: true)
            // tabBar.headerView.isHidden = true
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK:- Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTbl.dequeueReusableCell(withIdentifier: "settingTVC", for: indexPath) as! settingTVC
        cell.selectionStyle = .none
        cell.lbl.text = settingArr[indexPath.row]
        if indexPath.row == 2 {
            cell.lbl.textColor = GreenColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            showAlertWithOption("Logout", message: "Are you sure you want to logout?", completionConfirm: {
                AppDelegate().sharedDelegate().logoutApp()
            }) {
                
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class settingTVC : UITableViewCell {
    @IBOutlet weak var lbl: Label!
}
