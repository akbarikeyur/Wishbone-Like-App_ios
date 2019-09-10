
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire
import AlamofireJsonToObjects
import AlamofireImage
import SDWebImage

//Development
struct API {
    static let BASE_URL = "http://ec2-52-14-42-81.us-east-2.compute.amazonaws.com/development/api/"
    
    static let CREATE_USER          =       BASE_URL + "users/create"
    static let VERIFY_USER          =       BASE_URL + "users/verify"
    static let POST_LIST            =       BASE_URL + "posts/list"
    static let CREATE_POST          =       BASE_URL + "posts/create"
    static let CREATE_COMMENT       =       BASE_URL + "comments/create"
    static let COMMENT_LIST         =       BASE_URL + "comments/list"
    static let VOTE_POST            =       BASE_URL + "poll/create"
    static let CHANGE_PASSWORD      =       BASE_URL + "users/changePasswordEmail"
    static let RESET_PASSWORD       =       BASE_URL + "users/resetPassword"
    static let USER_UPDATE          =       BASE_URL + "users/update"
    static let USER_DETAIL          =       BASE_URL + "users/details"
    static let USER_SOCIAL_LOGIN    =       BASE_URL + "users/social"
}


public class APIManager {
    
    static let shared = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func toJson(_ dict:[String:Any]) -> String{
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    
    func getJsonHeader() -> [String:String]{
        return ["Content-Type":"application/json", "Accept":"application/json"]
    }
    
    func getMultipartHeader() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Accept":"application/json"]
    }
    
    /*
    func getJsonHeaderWithToken() -> [String:String] {
        return ["Content-Type":"application/json", "X-Requested-With":"XMLHttpRequest","Accept":"application/json", "Authorization": "Bearer " + AppModel.shared.currentUser.accessToken]
    }
    
    func getJsonHeaderParamWithToken() -> [String:String] {
        return ["Content-Type":"application/json","Accept":"application/json", "Authorization": "Bearer " + AppModel.shared.currentUser.accessToken]
    }

    func getMultipartHeaderWithToken() -> [String:String]{
        return ["Accept":"multipart/form-data", "Content-Type" : "multipart/form-data" ,"Authorization":"Bearer " + AppModel.shared.currentUser.accessToken]
    }
    
    func networkErrorMsg()
    {
        // removeLoader()
        showAlert("Greeky", message: "You are not connected to the internet") {
            
        }
    }
    
    func isServiceError(_ code: Int?) -> Bool{
        if(code == 401)
        {
            AppDelegate().sharedDelegate().logoutApp()
            return true
        }
        return false
    }
    */
    
    
    func serviceCallToCreateUser(profile: UIImage, _ param : [String : Any],_ completion: @escaping () -> Void){
        showLoader()
        let headerParams : [String : String] = getMultipartHeader()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            // pass Image
            if let imageData : Data = UIImagePNGRepresentation(profile)
            {
                multipartFormData.append(imageData, withName: "picture", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: API.CREATE_USER, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                upload.request.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.request.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : String = result["data"] as? String
                            {
                                print(data)
                                completion()
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                displayToast(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToLogin(_ param : [String : Any],  completion: @escaping () -> Void){
        showLoader()
        let headerParams : [String : String] = getMultipartHeader()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.CREATE_USER, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
        
                upload.request.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : String = result["data"] as? String
                            {
                                print(data)
                                setIsUserLogin(isUserLogin: true)
                                setAuthorizationTokenData(token: data as AnyObject)
                                completion()
                                return  
                            }
                            else if let message : String = result["message"] as? String
                            {
                                if let code : Int = result["code"] as? Int
                                {
                                    if code == 104 {
                                        displayToast("Your email/username or password is incorrect. Please try again.")
                                    } else {
                                        displayToast(message)
                                    }
                                }
                                print(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToAllPost(_ param : [String : Any], completion: @escaping (_ data:[[String:Any]]) -> Void){
        var headerParams : [String : String] = getJsonHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.request(API.POST_LIST, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let data : [[String : Any]] = result["data"] as? [[String : Any]]
                    {
                        completion(data)
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        completion([[String : Any]()])
                        print(message)
                        displayToast(message)
                        return
                    }
                }
                if let error = response.result.error
                {
                    completion([[String : Any]()])
                    print(error)
                    return
                }
                break
            case .failure(let error):
                completion([[String : Any]()])
                print(error)
                break
            }
        }
    }

    
    func serviceCallToUserPostList(_ param : [String:Any], completion: @escaping (_ data : [[String : Any]]) -> Void){

        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.POST_LIST, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                upload.request.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })

                upload.request.responseJSON { (response) in

                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]]
                            {
                                completion(data)
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                displayToast(message)
                                return
                            }
                        }

                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }

                        break
                    case .failure(let error):
                        print(error)
//                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToCreatePost(posts: [String:Any], param:[String:Any],completion: @escaping () -> Void){
        showLoader()
        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            for (key, value) in posts
            {
                if let imageData: Data = UIImagePNGRepresentation(value as! UIImage)! as Data
                {
                    multipartFormData.append(imageData, withName: key, fileName: "image.png", mimeType: "image/png")
                }
            }
        }, usingThreshold: UInt64.init(), to: API.CREATE_POST, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                upload.request.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.request.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [Any] = result["data"] as? [Any]
                            {
                                print(data)
                                completion()
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                displayToast(message)
                                completion()
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
//                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToCreateComment(_ param:[String:Any],completion: @escaping () -> Void){
        showLoader()
        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.CREATE_COMMENT, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                upload.request.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.request.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [Any] = result["data"] as? [Any]
                            {
                                print(data)
                                completion()
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                completion()
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
//                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToCommentList(_ param:[String:Any], completion: @escaping (_ data:[[String:Any]]) -> Void){
        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.COMMENT_LIST, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                
                upload.request.responseJSON { (response) in
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [[String:Any]] = result["data"] as? [[String:Any]]
                            {
                                completion(data)
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                displayToast(message)
                                // completion()
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
//                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToVote(_ param:[String:Any],completion: @escaping () -> Void){
        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: API.VOTE_POST, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                
                upload.request.responseJSON { (response) in
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [Any] = result["data"] as? [Any]
                            {
                                print(data)
                                completion()
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                // displayToast(message)
                                completion()
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
//                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToUserVotedPostList(_ param: [String:Any], completion: @escaping (_ data:[[String:Any]]) -> Void){

        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.POST_LIST, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):

                upload.request.responseJSON { (response) in

                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [[String:Any]] = result["data"] as? [[String:Any]]
                            {
                                completion(data)
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                displayToast(message)
                                return
                            }
                        }

                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }

                        break
                    case .failure(let error):
                        print(error)
//                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToChangePassword (_ param: [String:Any], completion: @escaping () -> Void){
        showLoader()
        let headerParams : [String : String] = getJsonHeader()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.CHANGE_PASSWORD, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                
                upload.request.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [[String:Any]] = result["data"] as? [[String:Any]]
                            {
                                print(data)
                                completion()
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                // displayToast(message)
                                completion()
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToResetPassword (_ param: [String:Any], completion: @escaping () -> Void){
        showLoader()
        let headerParams : [String : String] = getJsonHeader()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.RESET_PASSWORD, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                
                upload.request.responseJSON { (response) in
                    removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let code : Int = result["code"] as? Int
                            {
                                if code == 100 {
                                    completion()
                                } else {
                                    if let message : String = result["message"] as? String
                                    {
                                        displayToast("Wrong Pin")
                                        print(message)
                                        // displayToast(message)
                                        // displayToast("Please enter valid pin")
                                        return
                                    }
                                }
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToUpdateUser(_ profile: Image? ,_ param: [String:Any], completion: @escaping () -> Void){
        // showLoader()
        
        var headerParams : [String : String] = getMultipartHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if profile != nil
            {
                if let imgData : Data = UIImageJPEGRepresentation(profile!, 1.0)
                {
                    multipartFormData.append(imgData, withName: "image", fileName: "image.png", mimeType: "image/png")
                }
            }
            
        }, usingThreshold: UInt64.init(), to: API.USER_UPDATE, method: .post, headers: headerParams) { (result) in
            switch result{
            case .success(let upload):
                upload.request.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.request.responseJSON { (response) in
                    // removeLoader()
                    switch response.result {
                    case .success:
                        print(response.result.value!)
                        if let result : [String : Any] = response.result.value as? [String : Any]
                        {
                            if let data : [String:Any] = result["data"] as? [String:Any]
                            {
                                AppDelegate().sharedDelegate().getUserDetail()
                                displayToast("Your profile has been updated")
                                print(data)
                                completion()
                                return
                            }
                            else if let message : String = result["message"] as? String
                            {
                                print(message)
                                displayToast(message)
                                return
                            }
                        }
                        
                        if let error = response.result.error
                        {
                            displayToast(error.localizedDescription)
                            return
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        displayToast(error.localizedDescription)
                        break
                    }
                }
            case .failure(let error):
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToUserDetail(completion: @escaping (_ data:[String:Any]) -> Void){
        showLoader()
        var headerParams : [String : String] = getJsonHeader()
        headerParams["Authorization"] = getAuthorizationTokenData() as? String
        
        Alamofire.request(API.USER_DETAIL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let data : [String : Any] = result["data"] as? [String : Any]
                    {
                        completion(data)
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        print(message)
                    }
                }
                if let error = response.result.error
                {
                    print(error)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func serviceCallToSocialLogin(_ param : [String: Any], completion: @escaping () -> Void){
        showLoader()
        let headerParams : [String : String] = getJsonHeader()
        
        Alamofire.request(API.USER_SOCIAL_LOGIN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                print(response.result.value!)
                if let result : [String : Any] = response.result.value as? [String : Any]
                {
                    if let data : String = result["data"] as? String
                    {
                        setIsUserLogin(isUserLogin: true)
                        setAuthorizationTokenData(token: data as AnyObject)
                        completion()
                        return
                    }
                    else if let message : String = result["message"] as? String
                    {
                        print(message)
                    }
                }
                if let error = response.result.error
                {
                    print(error)
                    return
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }

    func serviceCallToGetPostImage(_ strUrl: String, _ imgView : [UIImageView]){
        
        let strUrl1 : String = GET_IMAGE_URL.POST + strUrl
        
        if strUrl1 == ""
        {
            for i in 0..<imgView.count{
                imgView[i].image = UIImage.init(named: "add_image")
            }
            return
        }
        
        for i in 0..<imgView.count{
            imgView[i].sd_setImage(with: URL(string : strUrl1)) { (image, error, catchType, url) in
                if error == nil
                {
                    imgView[i].image = image
                }
                else
                {
                    Alamofire.request(strUrl1, method: .get).responseImage { response in
                        guard let image = response.result.value else {
                            // Handle error
                            return
                        }
                        // Do stuff with your image
                        imgView[i].image = image
                    }
                }
            }
        }
    }
    
    func serviceCallToGetProfileImage(_ strUrl: String, _ button : [UIButton]){
        let strUrl1 : String = GET_IMAGE_URL.PROFILE + strUrl
        
        for i in 0..<button.count {
            button[i].sd_setBackgroundImage(with: URL(string : strUrl1), for: .normal) { (image, error, catchType, url) in
                if error == nil
                {
                    button[i].setBackgroundImage(image, for: .normal)
                }
                else
                {
                    button[i].setBackgroundImage(UIImage.init(named: "avatar"), for: .normal)
                }
            }
        }
    }
}
