//
//  AppDelegate.swift
//  Wishbone Like App
//
//  Created by PC on 29/11/18.
//  Copyright © 2018 PC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import CoreData
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var customTabbarVc : CustomTabBarController!
    var activityLoader : NVActivityIndicatorView!
    let fbLoginManager = FBSDKLoginManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // log in with google
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        
        // Login With Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        setDefaultBarStyle()
        
        if isUserLogin() == true
        {
            getUserDetail()
            AppDelegate().sharedDelegate().navigateToDashboard()
            print(getAuthorizationTokenData())
        }
        
        return true
    }
    
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK :- Status bar method
    func setDefaultBarStyle()
    {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
    }
    
    func setLightStatusBarStyle()
    {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    }
    
    // MARK :- Navigate To Dashboard
    func navigateToDashboard()
    {
        setLightStatusBarStyle()
        customTabbarVc = self.storyboard().instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
        if let rootNavigatioVC : UINavigationController = self.window?.rootViewController as? UINavigationController
        {
            rootNavigatioVC.pushViewController(customTabbarVc, animated: false)
        }
    }
    
    // MARK :- Loader Method
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = AppColor
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    func removeLoader()
    {
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }
    
    // MARK:- App Handler
    func getUserDetail()
    {
        APIManager.shared.serviceCallToUserDetail { (data) in
            AppModel.shared.curruntUserDetail = UserCommentModel.init(dict: data)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        }
    }

    // MARK :- Logout Method
    func logoutApp()
    {
        setIsUserLogin(isUserLogin: false)
        fbLoginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ViewControllerNavigation") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    // MARK:- GIDSignInDelegate
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.range(of: "facebook.com") != nil
        {
            // Facebook
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        }
        else
        {
            // Google
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
        }
    }
    
    // MARK:- Social Logins
    // Login With Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let email = user.profile.email
            let profile = user.profile.imageURL(withDimension: 0)
            
            let param:[String: Any] = ["socialType": 1,
                                       "socialId":userId!,
                                       "name":fullName!,
                                       "socialToken":idToken!,
                                       "picture": "\(profile!)",
                                       "email": email!]
            
            APIManager.shared.serviceCallToSocialLogin(param) {
                self.getUserDetail()
                self.navigateToDashboard()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print("Perform any operations when the user disconnects from app here")
    }
    
    // Login With Facebook
    func loginWithFacebook()
    {
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: window?.rootViewController) { (result, error) in
            if let error = error {
                showAlert("Error", message: error.localizedDescription, completion: {})
                return
            }
            
            guard let token = result?.token else {
                return
            }
            
            guard let accessToken = token.tokenString else {
                return
            }
            
            let request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "picture.width(500).height(500), email, id, name, first_name, last_name, gender"])
            
            let connection : FBSDKGraphRequestConnection = FBSDKGraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) in
                print(result as Any)
                
                if result != nil
                {
                    var param : [String: Any] = [String: Any]()
                    param["socialType"] = 2
                    param["socialToken"] = accessToken
                    
                    let dict = result as! [String : AnyObject]
                    if let temp : String = dict["email"] as? String
                    {
                        param["email"] = temp
                    }
                    
                    if let temp : String = dict["first_name"] as? String
                    {
                        print(temp)
                    }
                    
                    if let temp : String = dict["id"] as? String
                    {
                        param["socialId"] = temp
                    }
                    
                    if let temp : String = dict["last_name"] as? String
                    {
                        print(temp)
                    }
                    
                    if let temp : String = dict["name"] as? String
                    {
                        param["name"] = temp
                    }
                    
                    if let picture = dict["picture"] as? [String : Any]
                    {
                        if let data = picture["data"] as? [String : Any]
                        {
                            if let url = data["url"]
                            {
                                param["picture"] = url as? String
                            }
                        }
                    }
                    
                    APIManager.shared.serviceCallToSocialLogin(param, completion: {
                        self.getUserDetail()
                        self.navigateToDashboard()
                    })
                }
                else
                {
                    print(error ?? "error")
                }
            })
            connection.start()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WishboneLikeApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

/*
 * Get Top View Control
 *
 * Find the top view controller from queue and return it.
 * It's used in global function whenever need active View controller
 *
 * @param
 */
extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
