//
//  Button.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {
    
    var index : Int = 0
    
    @IBInspectable var textColorTypeAdapter : Int32 = 0 {
        didSet {
            self.textColorType = ColorType(rawValue: self.textColorTypeAdapter)
        }
    }
    var textColorType : ColorType? {
        didSet {
            self.setTitleColor(textColorType?.value, for: UIControlState.normal)
        }
    }
    
    @IBInspectable var fontTypeAdapter : String = FontType.SinhalaSangamRegular.value {
        didSet {
            self.fontType = FontType(rawValue: self.fontTypeAdapter)!
        }
    }
    var fontType : FontType = FontType.SinhalaSangamRegular {
        didSet {
            self.titleLabel?.font = UIFont(name: fontType.value, size: fontSize)!
        }
    }
    
    @IBInspectable var fontSize : CGFloat = 14 {
        didSet {
            self.titleLabel?.font = UIFont(name: fontType.value, size: fontSize)!
        }
    }
    
    @IBInspectable var backgroundColorTypeAdapter : Int32 = 0 {
        didSet {
            self.backgroundColorType = ColorType(rawValue: self.backgroundColorTypeAdapter)
        }
    }
    var backgroundColorType : ColorType? {
        didSet {
            setBackgroundColor(backgroundColorType: backgroundColorType)
        }
        
    }
    
    @IBInspectable var borderColorTypeAdapter : Int32 = 0 {
        didSet {
            self.borderColorType = ColorType(rawValue: self.borderColorTypeAdapter)
        }
    }
    var borderColorType : ColorType? {
        didSet {
            setBorderColor(borderColorType: borderColorType)
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            setCornerRadius(cornerRadius)
        }
    }
 
    @IBInspectable var gradientBackgroundTypeAdapter : Int32 = 0 {
        didSet {
            gradientBackgroundType = GradientColorType(rawValue: gradientBackgroundTypeAdapter) ?? .Clear
        }
    }
    
    var gradientBackgroundType : GradientColorType = .Clear {
        didSet {
            setGradientBackground(gradientBackgroundType: gradientBackgroundType)
        }
    }   
    
    @IBInspectable var shadowColorTypeAdapter : Int32 = 0 {
        didSet {
            if shadowColorTypeAdapter == 0 {
                self.layer.shadowRadius = 0
                self.layer.shadowColor = ColorType(rawValue: self.shadowColorTypeAdapter)?.value.cgColor
            }
            else
            {
                self.layer.masksToBounds = false;
                self.layer.shadowOffset = CGSize(width: 0.5, height: 3)
                self.layer.shadowColor = ColorType(rawValue: self.shadowColorTypeAdapter)?.value.cgColor
                self.layer.shadowOpacity = 0.5
                self.layer.shadowRadius = 3
            }
        }
    }
    
    @IBInspectable var applyShadowLikeAndroid : Int32 = 0 {
        didSet {
            if applyShadowLikeAndroid == 0 {
                self.layer.shadowRadius = 0
                self.layer.shadowColor = ColorType(rawValue: self.applyShadowLikeAndroid)?.value.cgColor
            } else {
                self.layer.masksToBounds = false;
                self.layer.shadowColor = ColorType(rawValue: self.applyShadowLikeAndroid)?.value.cgColor
                self.layer.shadowOpacity = 0.50
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowRadius = 7
            }
        }
    }

    var shadowColor : ColorType = .Clear {
        didSet {
            self.layer.shadowColor = (ColorType(rawValue: shadowColor.rawValue) as! CGColor)
        }
    }    
    
    @IBInspectable var tintColorType : Int32 = 0 {
        didSet {
            setTintColor(tintColorType: ColorType(rawValue: self.tintColorType))
        }
    }
}
