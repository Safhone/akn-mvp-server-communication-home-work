//
//  CustomUIButton.swift
//  Article-Homework
//
//  Created by Safhone Oung on 12/25/17.
//  Copyright © 2017 Safhone Oung. All rights reserved.
//

import UIKit

@IBDesignable class CustomUIButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: -1, height: 1)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = shadowRadius
        }
    }
    
}
