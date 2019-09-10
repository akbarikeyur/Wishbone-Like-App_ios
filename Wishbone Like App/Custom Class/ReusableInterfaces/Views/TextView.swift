//
//  TextView.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

//@IBDesignable
class TextView: UITextView {

    let placeholderLabel: Label = Label()
    var placeholderTopSpace : CGFloat = 0.0
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       //self.contentInset = UIEdgeInsetsMake(12,12,12,12);
        self.bounces = false
        self.alwaysBounceHorizontal = false
       // self.scrollEnabled = false
        self.textContainer.lineFragmentPadding = 12
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBInspectable var textColorTypeAdapter : Int32 = 0 {
        didSet {
            self.textColorType = ColorType(rawValue: self.textColorTypeAdapter)
        }
    }
    var textColorType : ColorType? {
        didSet {
            self.textColor = textColorType?.value
        }
    }
    
   
    @IBInspectable var backGroundColorTypeAdapter : Int32 = 0 {
        didSet {
            self.backgroundColorType = ColorType(rawValue: self.backGroundColorTypeAdapter)
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
    
    @IBInspectable var fontTypeAdapter : String = FontType.SinhalaSangamRegular.value {
        didSet {
            self.fontType = FontType(rawValue: self.fontTypeAdapter)!
        }
    }
    var fontType : FontType = FontType.SinhalaSangamRegular {
        didSet {
            self.font = UIFont(name: fontType.value, size: fontSize)!
        }
    }
    
    @IBInspectable var fontSize : CGFloat = 12 {
        didSet {
            self.font = UIFont(name: fontType.value, size: fontSize)!
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            setCornerRadius(cornerRadius)
        }
    }
    
    @IBInspectable var placeholderTopMargin : CGFloat = 0 {
        didSet {
            placeholderTopSpace = placeholderTopMargin
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder.decoded
        }
    }
    
    @IBInspectable var placeholderColorTypeAdapter : Int32 = 0 {
        didSet {
            self.placeholderColorType = ColorType(rawValue: self.placeholderColorTypeAdapter)
        }
    }
    
    var placeholderColorType : ColorType? {
        didSet {
            placeholderLabel.textColorType = placeholderColorType
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: nil)
        placeholderLabel.font = UIFont(name: SEGO_UI_REGULAR, size: 16)
        placeholderLabel.textColorType = placeholderColorType
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder.decoded
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\((textContainerInset.left + 5) + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top + placeholderTopMargin))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -((textContainerInset.left + 5) + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextViewTextDidChange,
                                                  object: nil)
    }
}
