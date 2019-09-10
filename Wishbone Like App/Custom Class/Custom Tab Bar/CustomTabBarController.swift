//
//  CustomTabBarController.swift
//  Event Project
//
//  Created by Amisha on 20/07/17.
//  Copyright © 2017 AK Infotech. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,CustomTabBarViewDelegate {
   
    var tabBarView : CustomTabBarView = CustomTabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToTabBar(noti:)), name: NSNotification.Name.init(NOTIFICATION.REDICT_TAB_BAR), object: nil)
        
        tabBarView = Bundle.main.loadNibNamed("CustomTabBarView", owner: nil, options: nil)?.last as! CustomTabBarView
        tabBarView.delegate = self
        addTabBarView()
        setup()
    }
    
    // MARK: - COMMON HEADER METHODE
    
    @objc func locationBtnTap(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_SCREEN"), object: ["type" : 3])
    }
    
    func notificationTap(sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_SCREEN"), object: ["type" : 2])
    }
    func profileTap(sender: UIButton) {
         NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_SCREEN"), object: ["type" : 1])
       
    }
    func settingTap(sender: UIButton) {
         NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_SCREEN"), object: ["type" : 4])
       
    }
    
    func displayHeaderViewtoParentView(_ parentview: UIView! , subview: UIView!)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        parentview.addSubview(subview);
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
    }
    
    @objc func redirectToTabBar(noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any]
        {
            if let index : Int = dict["tabIndex"] as? Int
            {
                tabBarView.resetAllButton()
                tabBarView.lastIndex = 0
                tabBarView.selectTabButton()
                tabSelectedAtIndex(index: index)
            }
        }
    }
    
    //MARK: - CUSTOM TABBAR SETUP
    func setup()
    {
        var viewControllers = [UINavigationController]()
        let navController1 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NavigationDashboard") as! UINavigationController
        viewControllers.append(navController1)
        
        let navController2 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NavigationFeed") as! UINavigationController
        viewControllers.append(navController2)
        
        let navController3 : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NavigationProfile") as! UINavigationController
        viewControllers.append(navController3)
        
        self.viewControllers = viewControllers;
        
        self.tabBarView.btn1.isSelected = true;
        self.tabSelectedAtIndex(index: 0)
    }
    
    func tabSelectedAtIndex(index: Int) {
        setSelectedViewController(selectedViewController: (self.viewControllers?[index])!, tabIndex: index)
    }
    
    func setSelectedViewController(selectedViewController:UIViewController, tabIndex:Int)
    {
        // pop to root if tapped the same controller twice
        if self.selectedViewController == selectedViewController {
            (self.selectedViewController as! UINavigationController).popToRootViewController(animated: true)
        }
        super.selectedViewController = selectedViewController
    }
    
    func addTabBarView()
    {
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tabBarView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 50.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: ((UIScreen.main.bounds.size.height == 812) ? -34 : 0)))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tabBarView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        self.view.layoutIfNeeded()
    }
    
    func tabBarHidden() -> Bool
    {
        return self.tabBarView.isHidden && self.tabBar.isHidden
    }
    
    func setTabBarHidden(tabBarHidden:Bool)
    {
        self.tabBarView.isHidden = tabBarHidden
        self.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
