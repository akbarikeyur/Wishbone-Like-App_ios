//
//  Fonts.swift
//  Cozy Up
//
//  Created by Amisha on 22/05/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import Foundation

import UIKit

let SINHALA_SAMGAM_REGULAR = "SinhalaSangamMN"
let QUESTRIAL_REQULAR = "Questrial-Regular"

let ROBOTO_REGULAR = "Roboto-Regular"
let ROBOTO_MEDIUM = "Roboto-Medium"

let SEGO_UI_REGULAR = "SegoeUI"
let SEGO_UI_SEMI_BOLG = "SegoeUI-Semibold"


enum FontType : String {
    case Clear = ""
    
    case SinhalaSangamRegular = "ssr"
    case QuestrialRegular = "qr"
    
    case RobotoRegular = "rr"
    case RobotoMedium = "rm"
    
    case SegoUiRegular = "sr"
    case SegoUiSemibol = "ss"
    
}


extension FontType {
    var value: String {
        get {
            switch self {
            case .Clear:
                return SINHALA_SAMGAM_REGULAR
                
            case .SinhalaSangamRegular :
                return SINHALA_SAMGAM_REGULAR
            case .QuestrialRegular :
                return QUESTRIAL_REQULAR
                
            case .RobotoRegular:
                return ROBOTO_REGULAR
            case .RobotoMedium:
                return ROBOTO_MEDIUM
                
            case .SegoUiRegular:
                return SEGO_UI_REGULAR
            case .SegoUiSemibol:
                return SEGO_UI_SEMI_BOLG
            }
        }
    }
}

