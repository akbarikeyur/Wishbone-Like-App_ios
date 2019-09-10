//
//  AppModel.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//
import UIKit


class AppModel: NSObject {
    static let shared = AppModel()
    
    var curruntUserDetail:UserCommentModel!
    
    func validOptionsArrOfDistionary(arr: [ValidOptionsModel]) -> [[String:Any]] //validOptions
    {
        let len = arr.count
        var validOptionsArr: [[String:Any]] = [[String:Any]]()
        for i in 0..<len {
            validOptionsArr.append(arr[i].dictionary())
        }
        return validOptionsArr
    }
}

class PostListModel : AppModel {
    var date: String!
    var timezone: String!
    var options: [String]!
    var _id: String!
    var ref: String!
    var title: String!
    var content: String!
    var validOptions: [ValidOptionsModel]!
    var id: String!
    var totalVote: Int!
    var comments: Int!
    var user: UserCommentModel!
    var isPolled:Bool!
    
    override init() {
        date = ""
        timezone = ""
        options = [String]()
        _id = ""
        ref = ""
        title = ""
        content = ""
        validOptions = [ValidOptionsModel]()
        totalVote = 0
        comments = 0
        user = UserCommentModel.init()
        isPolled = false
    }
    
    init(dict : [String : Any]) {
        date = ""
        timezone = ""
        options = [String]()
        _id = ""
        ref = ""
        title = ""
        content = ""
        validOptions = [ValidOptionsModel]()
        comments = 0
        user = UserCommentModel.init()
        isPolled = false
        
        if let temp = dict["date"] as? String {
            date = temp
        }
        if let temp = dict["timezone"] as? String {
            timezone = temp
        }
        if let temp = dict["options"] as? [String] {
            options = temp
        }
        if let temp = dict["_id"] as? String {
            _id = temp
        }
        if let temp = dict["ref"] as? String {
            ref = temp
        }
        if let temp = dict["title"] as? String {
            title = temp
        }
        if let temp = dict["content"] as? String {
            content = temp
        }
        if let temp = dict["pollingData"] as? [[String:Any]] {
            validOptions = [ValidOptionsModel]()
            let len = temp.count
            totalVote = 0
            for i in 0..<len {
                self.validOptions.append(ValidOptionsModel.init(dict: temp[i]))
                totalVote = totalVote + validOptions[i].total
            }
        }
        if let temp = dict["comments"] as? Int {
            comments = temp
        }
        if let temp = dict["user"] as? [String:Any] {
            user = UserCommentModel.init(dict: temp)
        }
        if let temp = dict["isPolled"] as? Bool {
            isPolled = temp
        }
    }
    
    func dictionary() -> [String:Any] {
        return ["date":date, "timezone":timezone, "options":options, "_id":_id, "ref":ref, "title":title, "content":content, "pollingData":validOptionsArrOfDistionary(arr: validOptions), "comments":comments, "user": user.dictionary(), "isPolled":isPolled]
    }
}

class ValidOptionsModel: AppModel {
    var percentage: Float!
    var _id: String!
    var ref: String!
    var by: String!
    var picture: String!
    var __v: Int!
    var total: Int!
    var url: String!
    var caption : String!
    
    override init() {
        percentage = 0.0
        _id = ""
        ref = ""
        by = ""
        picture = ""
        __v = 0
        total = 0
        url = ""
        caption = ""
    }
    
   init(dict: [String:Any]) {
        percentage = 0.0
        _id = ""
        ref = ""
        by = ""
        picture = ""
        __v = 0
        total = 0
        url = ""
        caption = ""
        
        if let temp = dict["percentage"] as? Float {
            percentage = temp
        } else if let temp = dict["percentage"] as? Double {
            percentage = Float(temp)
        }
        if let temp = dict["_id"] as? String {
            _id = temp
        }
        if let temp = dict["ref"] as? String {
            ref = temp
        }
        if let temp = dict["by"] as? String {
            by = temp
        }
        if let temp = dict["picture"] as? String {
            picture = temp
        }
        if let temp = dict["__v"] as? Int {
            __v = temp
        }
        if let temp = dict["total"] as? Int {
            total = temp
        }
        if let temp = dict["url"] as? String {
            url = temp
        }
        if let temp = dict["caption"] as? String {
            caption = temp
        }
    }
    
    func dictionary() -> [String:Any] {
        return ["percentage":percentage, "_id":_id, "ref":ref, "by":by, "picture":picture, "__v":__v, "total":total, "url":url, "caption":caption]
    }
}

class CommentModel : AppModel {
    var date: String!
    var timezone: String!
    var _id: String!
    var ref: String!
    var by: String!
    var content: String!
    var user: UserCommentModel!
    
    override init() {
        date = ""
        timezone = ""
        _id = ""
        ref = ""
        by = ""
        content = ""
        user = UserCommentModel()
    }
    
    init(dict: [String:Any]) {
        date = ""
        timezone = ""
        _id = ""
        ref = ""
        by = ""
        content = ""
        user = UserCommentModel()
        
        if let temp = dict["date"] as? String {
            date = temp
        }
        if let temp = dict["timezone"] as? String {
            timezone = temp
        }
        if let temp = dict["_id"] as? String {
            _id = temp
        }
        if let temp = dict["ref"] as? String {
            ref = temp
        }
        if let temp = dict["by"] as? String {
            by = temp
        }
        if let temp = dict["content"] as? String {
            content = temp
        }
        if let temp = dict["user"] as? [String:Any] {
            user = UserCommentModel.init(dict: temp)
        }
        
    }
    
    func dictionary() -> [String:Any] {
        return ["date":date, "timezone":timezone, "_id":_id, "ref":ref, "by":by, "content":content, "user":user.dictionary()]
    }
}

class UserCommentModel : AppModel {
    var _id: String!
    var userName: String!
    var email: String!
    var picture: String!
    
    override init() {
        _id = ""
        userName = ""
        email = ""
        picture = ""
    }
    
    init(dict: [String:Any]) {
        _id = ""
        userName = ""
        email = ""
        picture = ""
        
        if let temp = dict["_id"] as? String {
            _id = temp
        }
        if let temp = dict["userName"] as? String {
            userName = temp
        }
        if let temp = dict["email"] as? String {
            email = temp
        }
        if let temp = dict["picture"] as? String {
            picture = temp
        }
    }
    
    func dictionary() -> [String:Any] {
        return ["_id":_id, "userName":userName, "email":email, "picture":picture]
    }
}
