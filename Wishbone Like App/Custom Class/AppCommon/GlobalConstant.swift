//
//  GlobalConstant.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation
import UIKit


let APP_VERSION = 1.0
let BUILD_VERSION = 1
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString

let ITUNES_URL = ""
let GOOGLE_CLIENT_ID = "636799164282-tce2ichpjr4m3bb23koui94p8qvnmvmq.apps.googleusercontent.com"

struct SCREEN
{
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

struct GET_IMAGE_URL {
    static var PROFILE = "http://ec2-52-14-42-81.us-east-2.compute.amazonaws.com/development/api/general/image?path=profile&identifier="
    static var POST = "http://ec2-52-14-42-81.us-east-2.compute.amazonaws.com/development/api/general/image?path=option&identifier="
}

struct DATE_FORMAT {
    static var SERVER_DATE_FORMAT = "dd/MM/yyyy"
    static var SERVER_TIME_FORMAT = "HH:mm"
    static var SERVER_DATE_TIME_FORMAT = "yyyy-MM-dd" //HH:mm:ss"
    static var DISPLAY_DATE_FORMAT = "dd/MM/yyyy"
    static var DISPLAY_DATE_FORMAT1 = "MM/dd/yyyy"
    static var DISPLAY_TIME_FORMAT = "hh:mm a"
    static var DISPLAY_DATE_TIME_FORMAT = "dd/MM/yyyy HH:mm"
}

struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    
}

struct NOTIFICATION {
    static var UPDATE_CURRENT_USER_DATA     =   "UPDATE_CURRENT_USER_DATA"
    static var UPDATE_SELECTION_DATA        =   "UPDATE_SELECTION_DATA"
    static var UPDATE_SELECTION_IMAGE       =   "UPDATE_SELECTION_IMAGE"
    static var REDICT_TAB_BAR               =   "REDICT_TAB_BAR"
    static var GET_ALL_POPST                =   "GET_ALL_POPST"
    static var UPDATE_POST_DATA             =   "UPDATE_POST_DATA"
    static var UPDATE_USET_POST_DATA        =   "UPDATE_USET_POST_DATA"
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

