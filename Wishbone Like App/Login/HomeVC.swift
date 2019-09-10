//
//  HomeVC.swift
//  Wishbone Like App
//
//  Created by PC on 07/12/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- Button Click
    @IBAction func clickToSignIn(_ sender: Any) {
        self.view.endEditing(true)
        let vc : ViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
