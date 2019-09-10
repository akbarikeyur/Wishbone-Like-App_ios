//
//  Colors.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = UIColor.white //1
var AppColor : UIColor = colorFromHex(hex: "1D8B88") //2
var DarkGrayColor : UIColor = colorFromHex(hex: "4C4C4C") //3
var LightGrayColor : UIColor = colorFromHex(hex: "9A9A9A") //4
var ExtraLightGrayColor : UIColor = colorFromHex(hex: "DDDDDD") //5
var BlackColor : UIColor = colorFromHex(hex: "000000") //6
var NaviBlueColor : UIColor = colorFromHex(hex: "1D486B") //7
var GreenColor : UIColor = colorFromHex(hex: "1D9B88") //8
var InputColor : UIColor = colorFromHex(hex: "3A3A3A") //9
var LineColor : UIColor = colorFromHex(hex: "D1D3D4") //10

enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case App = 2
    case DarkGray = 3
    case LightGray = 4
    case ExtraLightGray = 5
    case Black = 6
    case NaviBlue = 7
    case Green = 8
    case Input = 9
    case Line = 10

}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
            case .Clear: //0
                return ClearColor
            case .White: //1
                return WhiteColor
            case .App: //2
                return AppColor
            case .DarkGray: //3
                return DarkGrayColor
            case .LightGray: //4
                return LightGrayColor
            case .ExtraLightGray: //5
                return ExtraLightGrayColor
            case .Black: //6
                return BlackColor
            case .NaviBlue: //7
                return NaviBlueColor
            case .Green: //8
                return GreenColor
            case .Input: //9
                return InputColor
            case .Line: //10
                return LineColor
            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case App = 1
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
                    NaviBlueColor.cgColor,
                    GreenColor.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}

